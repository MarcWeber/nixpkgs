# deprecated - only for my old PHP setup to keep it working
{lib, pkgs}:
let inherit (builtins) filter isAttrs attrValues;
    inherit (lib) attrNames listToAttrs fold foldl nameValuePair mapAttrs mergeAttrBy;

  # calls a function (f attr value ) for each record item. returns a list
  mapAttrsFlatten = f: r: map (attr: f attr r.${attr}) (attrNames r);

  # attribute set containing one attribute
  nvs = name: value: listToAttrs [ (nameValuePair name value) ];
  # adds / replaces an attribute of an attribute set
  setAttr = set: name: v: set // (nvs name v);

  # setAttrMerge (similar to mergeAttrsWithFunc but only merges the values of a particular name)
  # setAttrMerge "a" [] { a = [2];} (x: x ++ [3]) -> { a = [2 3]; }
  # setAttrMerge "a" [] {         } (x: x ++ [3]) -> { a = [  3]; }
  setAttrMerge = name: default: attrs: f:
    setAttr attrs name (f (maybeAttr name default attrs));

  defaultMergeArg = x : y: if builtins.isAttrs y then
    y
  else
    (y x);
  defaultMerge = x: y: x // (defaultMergeArg x y);

  foldArgs = merger: f: init: x:
    let arg = (merger init (defaultMergeArg init x));
        # now add the function with composed args already applied to the final attrs
        base = (setAttrMerge "passthru" {} (f arg)
                        ( z: z // rec {
                            function = foldArgs merger f arg;
                            args = (lib.attrByPath ["passthru" "args"] {} z) // x;
                          } ));
        withStdOverrides = base // {
          override = base.passthru.function;
        };
        in
          withStdOverrides;

  composedArgsAndFun = f: foldArgs defaultMerge f {};

  # prepareDerivationArgs tries to make writing configurable derivations easier
  # example:
  #  prepareDerivationArgs {
  #    mergeAttrBy = {
  #       myScript = x: y: x ++ "\n" ++ y;
  #    };
  #    cfg = {
  #      readlineSupport = true;
  #    };
  #    flags = {
  #      readline = {
  #        set = {
  #           configureFlags = [ "--with-compiler=${compiler}" ];
  #           buildInputs = [ compiler ];
  #           pass = { inherit compiler; READLINE=1; };
  #           assertion = compiler.dllSupport;
  #           myScript = "foo";
  #        };
  #        unset = { configureFlags = ["--without-compiler"]; };
  #      };
  #    };
  #    src = ...
  #    buildPhase = '' ... '';
  #    name = ...
  #    myScript = "bar";
  #  };
  # if you don't have need for unset you can omit the surrounding set = { .. } attr
  # all attrs except flags cfg and mergeAttrBy will be merged with the
  # additional data from flags depending on config settings
  # It's used in composableDerivation in all-packages.nix. It's also used
  # heavily in the new python and libs implementation
  #
  # should we check for misspelled cfg options?
  # TODO use args.mergeFun here as well?
  prepareDerivationArgs = args:
    let args2 = { cfg = {}; flags = {}; } // args;
        flagName = name: "${name}Support";
        cfgWithDefaults = (listToAttrs (map (n: nameValuePair (flagName n) false) (attrNames args2.flags)))
                          // args2.cfg;
        opts = attrValues (mapAttrs (a: v:
                let v2 = if v ? set || v ? unset then v else { set = v; };
                    n = if cfgWithDefaults.${flagName a} then "set" else "unset";
                    attr = maybeAttr n {} v2; in
                if (maybeAttr "assertion" true attr)
                  then attr
                  else throw "assertion of flag ${a} of derivation ${args.name} failed"
               ) args2.flags );
    in removeAttrs
      (mergeAttrsByFuncDefaults ([args] ++ opts ++ [{ passthru = cfgWithDefaults; }]))
      ["flags" "cfg" "mergeAttrBy" ];

  # shortcut for attrByPath ["name"] default attrs
  maybeAttrNullable = maybeAttr;

  # shortcut for attrByPath ["name"] default attrs
  maybeAttr = name: default: attrs: attrs.${name} or default;

  # example usage:
  # mergeAttrByFunc  {
  #   inherit mergeAttrBy; # defined below
  #   buildInputs = [ a b ];
  # } {
  #  buildInputs = [ c d ];
  # };
  # will result in
  # { mergeAttrsBy = [...]; buildInputs = [ a b c d ]; }
  # is used by prepareDerivationArgs, defaultOverridableDelayableArgs and can be used when composing using
  # foldArgs, composedArgsAndFun or applyAndFun. Example: composableDerivation in all-packages.nix
  mergeAttrByFunc = x: y:
    let
          mergeAttrBy2 = { mergeAttrBy = lib.mergeAttrs; }
                      // (maybeAttr "mergeAttrBy" {} x)
                      // (maybeAttr "mergeAttrBy" {} y); in
    fold lib.mergeAttrs {} [
      x y
      (mapAttrs ( a: v: # merge special names using given functions
          if x ? ${a}
             then if y ? ${a}
               then v x.${a} y.${a} # both have attr, use merge func
               else x.${a} # only x has attr
             else y.${a} # only y has attr)
          ) (removeAttrs mergeAttrBy2
                         # don't merge attrs which are neither in x nor y
                         (filter (a: ! x ? ${a} && ! y ? ${a})
                                 (attrNames mergeAttrBy2))
            )
      )
    ];
  mergeAttrsByFuncDefaults = foldl mergeAttrByFunc { inherit mergeAttrBy; };
  mergeAttrsByFuncDefaultsClean = list: removeAttrs (mergeAttrsByFuncDefaults list) ["mergeAttrBy"];


  # predecessors: proposed replacement for applyAndFun (which has a bug cause it merges twice)
  # the naming "overridableDelayableArgs" tries to express that you can
  # - override attr values which have been supplied earlier
  # - use attr values before they have been supplied by accessing the fix point
  #   name "fixed"
  # f: the (delayed overridden) arguments are applied to this
  #
  # initial: initial attrs arguments and settings. see defaultOverridableDelayableArgs
  #
  # returns: f applied to the arguments // special attributes attrs
  #     a) merge: merge applied args with new args. Wether an argument is overridden depends on the merge settings
  #     b) replace: this let's you replace and remove names no matter which merge function has been set
  #
  # examples: see test cases "res" below;
  overridableDelayableArgs =
          f:        # the function applied to the arguments
          initial:  # you pass attrs, the functions below are passing a function taking the fix argument
    let
        takeFixed = if lib.isFunction initial then initial else (fixed : initial); # transform initial to an expression always taking the fixed argument
        tidy = args:
            let # apply all functions given in "applyPreTidy" in sequence
                applyPreTidyFun = fold ( n: a: x: n ( a x ) ) lib.id (maybeAttr "applyPreTidy" [] args);
            in removeAttrs (applyPreTidyFun args) ( ["applyPreTidy"] ++ (maybeAttr  "removeAttrs" [] args) ); # tidy up args before applying them
        fun = n: x:
            let newArgs = fixed:
                    let args = takeFixed fixed;
                        mergeFun = args.${n};
                    in if isAttrs x then (mergeFun args x)
                       else assert lib.isFunction x;
                            mergeFun args (x ( args // { inherit fixed; }));
            in overridableDelayableArgs f newArgs;
    in
    (f (tidy (lib.fix takeFixed))) // {
      merge   = fun "mergeFun";
      replace = fun "keepFun";
    };
  defaultOverridableDelayableArgs = f:
      let defaults = {
            mergeFun = mergeAttrByFunc; # default merge function. merge strategie (concatenate lists, strings) is given by mergeAttrBy
            keepFun = a: b: { inherit (a) removeAttrs mergeFun keepFun mergeAttrBy; } // b; # even when using replace preserve these values
            applyPreTidy = []; # list of functions applied to args before args are tidied up (usage case : prepareDerivationArgs)
            mergeAttrBy = mergeAttrBy // {
              applyPreTidy = a: b: a ++ b;
              removeAttrs = a: b: a ++ b;
            };
            removeAttrs = ["mergeFun" "keepFun" "mergeAttrBy" "removeAttrs" "fixed" ]; # before applying the arguments to the function make sure these names are gone
          };
      in (overridableDelayableArgs f defaults).merge;


in
{

  # composableDerivation basically mixes these features:
  # - fix function
  # - mergeAttrBy
  # - provides shortcuts for "options" such as "--enable-foo" and adding
  #   buildInputs, see php example
  #
  # It predates styles which are common today, such as
  #  * the config attr
  #  * mkDerivation.override feature
  #  * overrideDerivation (lib/customization.nix)
  #
  # Some of the most more important usage examples (which could be rewritten if it was important):
  # * php
  # * postgis
  # * vim_configurable
  #
  # A minimal example illustrating most features would look like this:
  # let base = composableDerivation { (fixed: let inherit (fixed.fixed) name in {
  #    src = fetchurl {
  #    }
  #    buildInputs = [A];
  #    preConfigre = "echo ${name}";
  #    # attention, "name" attr is missing, thus you cannot instantiate "base".
  # }
  # in {
  #  # These all add name attribute, thus you can instantiate those:
  #  v1 = base.merge   ({ name = "foo-add-B"; buildInputs = [B]; });       // B gets merged into buildInputs
  #  v2 = base.merge   ({ name = "mix-in-pre-configure-lines" preConfigre = ""; });
  #  v3 = base.replace ({ name = "foo-no-A-only-B;" buildInputs = [B]; });
  # }
  #
  # So yes, you can think about it being something like nixos modules, and
  # you'd be merging "features" in one at a time using .merge or .replace
  # Thanks Shea for telling me that I rethink the documentation ..
  #
  # issues:
  # * its complicated to understand
  # * some "features" such as exact merge behaviour are buried in mergeAttrBy
  #   and defaultOverridableDelayableArgs assuming the default behaviour does
  #   the right thing in the common case
  # * Eelco once said using such fix style functions are slow to evaluate
  # * Too quick & dirty. Hard to understand for others. The benefit was that
  #   you were able to create a kernel builder like base derivation and replace
  #   / add patches the way you want without having to declare function arguments
  #
  # nice features:
  # declaring "optional features" is modular. For instance:
  #   flags.curl = {
  #     configureFlags = ["--with-curl=${curl.dev}" "--with-curlwrappers"];
  #     buildInputs = [curl openssl];
  #   };
  #   flags.other = { .. }
  # (Example taken from PHP)
  #
  # alternative styles / related features:
  #  * Eg see function supporting building the kernel
  #  * versionedDerivation (discussion about this is still going on - or ended)
  #  * composedArgsAndFun
  #  * mkDerivation.override
  #  * overrideDerivation
  #  * using { .., *Support ? false }: like configurable options.
  # To find those examples use grep
  #
  # To sum up: It exists for historical reasons - and for most commonly used
  # tasks the alternatives should be used
  #
  # If you have questions about this code ping Marc Weber.
  composableDerivation = {
        mkDerivation ? pkgs.stdenv.mkDerivation,

        # list of functions to be applied before defaultOverridableDelayableArgs removes removeAttrs names
        # prepareDerivationArgs handles derivation configurations
        applyPreTidy ? [ prepareDerivationArgs ],

        # consider adding addtional elements by derivation.merge { removeAttrs = ["elem"]; };
        removeAttrs ? ["cfg" "flags"]

      }: (defaultOverridableDelayableArgs ( a: mkDerivation a)
         {
           inherit applyPreTidy removeAttrs;
         }).merge;

  # some utility functions
  # use this function to generate flag attrs for prepareDerivationArgs
  # E nable  D isable F eature
  edf = {name, feat ? name, enable ? {}, disable ? {} , value ? ""}:
    nvs name {
    set = {
      configureFlags = ["--enable-${feat}${if value == "" then "" else "="}${value}"];
    } // enable;
    unset = {
      configureFlags = ["--disable-${feat}"];
    } // disable;
  };

  # same for --with and --without-
  # W ith or W ithout F eature
  wwf = {name, feat ? name, enable ? {}, disable ? {}, value ? ""}:
    nvs name {
    set = enable // {
      configureFlags = ["--with-${feat}${if value == "" then "" else "="}${value}"]
                       ++ lib.maybeAttr "configureFlags" [] enable;
    };
    unset = disable // {
      configureFlags = ["--without-${feat}"]
                       ++ lib.maybeAttr "configureFlags" [] disable;
    };
  };
}
