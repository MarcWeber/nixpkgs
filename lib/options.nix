# Nixpkgs/NixOS option handling.

let lib = import ./default.nix; in

with import ./trivial.nix;
with import ./lists.nix;
with import ./misc.nix;
with import ./attrsets.nix;
with import ./strings.nix;

rec {

  isOption = lib.isType "option";
  mkOption =
    { default ? null # Default value used when no definition is given in the configuration.
    , defaultText ? null # Textual representation of the default, for in the manual.
    , example ? null # Example value used in the manual.
    , description ? null # String describing the option.
    , type ? null # Option type, providing type-checking and value merging.
    , apply ? null # Function that converts the option value to something else.
    , internal ? null # Whether the option is for NixOS developers only.
    , visible ? null # Whether the option shows up in the manual.
    , options ? null # Obsolete, used by types.optionSet.
    } @ attrs:
    attrs // { _type = "option"; };

  mkEnableOption = name: mkOption {
    default = false;
    example = true;
    description = "Whether to enable ${name}.";
    type = lib.types.bool;
  };

<<<<<<< HEAD
  mapSubOptions = f: opt:
    if opt ? options then
      opt // {
        options = imap f (toList opt.options);
      }
    else
      opt;

  # Make the option declaration more user-friendly by adding default
  # settings and some verifications based on the declaration content (like
  # type correctness).
  addOptionMakeUp = {name, recurseInto}: decl:
    let
      init = {
        inherit name;
        merge = mergeDefaultOption;
        apply = lib.id;
      };

      functionsFromType = opt:
        opt // (builtins.intersectAttrs { merge = 1; check = 1; } (decl.type or {})); 

      addDeclaration = opt: opt // decl;

      ensureMergeInputType = opt:
        if opt ? check then
          opt // {
            merge = list:
              if all opt.check list then
                opt.merge list
              else
                throw "${name} has one value not passing the check function.";
          }
        else opt;

      checkDefault = opt:
        if opt ? check && opt ? default then
          opt // {
            default =
              if opt.check opt.default then
                opt.default
              else
                throw "The default value of ${name} doesn't pass the check function.";
          }
        else opt;

      handleOptionSets = opt:
        if opt ? type && opt.type.hasOptions then
          let
            # Evaluate sub-modules.
            subModuleMerge = path: vals:
              lib.fix (args:
                let
                  result = recurseInto path (opt.options ++ imap (index: v: args: {
                    key = rec {
                      #!!! Would be nice if we had the file the val was from
                      option = path;
                      number = index;
                      outPath = "option ${option} config number ${toString number}";
                    };
                  } // (lib.applyIfFunction v args)) (toList vals)) args;
                  name = lib.removePrefix (opt.name + ".") path;
                  extraArgs = opt.extraArgs or {};
                  individualExtraArgs = opt.individualExtraArgs or {};
                in {
                  inherit (result) config options;
                  inherit name;
                } //
                  (opt.extraArgs or {}) //
                  (if hasAttr name individualExtraArgs then getAttr name individualExtraArgs else {})
              );

            # Add _options in sub-modules to make it viewable from other
            # modules.
            subModuleMergeConfig = path: vals:
              let result = subModuleMerge path vals; in
                { _args = result; } // result.config;

          in
            opt // {
              merge = list:
                opt.type.iter
                  subModuleMergeConfig
                  opt.name
                  (opt.merge list);
              options =
                let path = opt.type.docPath opt.name; in
                  (subModuleMerge path []).options;
            }
        else
          opt;
    in
      foldl (opt: f: f opt) init [
        # default settings
        functionsFromType

        # user settings
        addDeclaration

        # override settings
        ensureMergeInputType
        checkDefault
        handleOptionSets
      ];

  # Merge a list of options containning different field.  This is useful to
  # separate the merge & apply fields from the interface.
  mergeOptionDecls = opts:
    if opts == [] then {}
    else if length opts == 1 then
      let opt = head opts; in
      if opt ? options then
        opt // { options = toList opt.options; }
      else
        opt
    else
      fold (opt1: opt2:
        lib.addErrorContext "opt1 = ${lib.showVal opt1}\nopt2 = ${lib.showVal opt2}" (
        # You cannot merge if two options have the same field.
        assert opt1 ? default -> ! opt2 ? default;
        assert opt1 ? example -> ! opt2 ? example;
        assert opt1 ? description -> ! opt2 ? description;
        assert opt1 ? merge -> ! opt2 ? merge;
        assert opt1 ? apply -> ! opt2 ? apply;
        assert opt1 ? type -> ! opt2 ? type;
        opt1 // opt2
        // optionalAttrs (opt1 ? options || opt2 ? options) {
            options =
               (toList (opt1.options or []))
            ++ (toList (opt2.options or []));
          }
        // optionalAttrs (opt1 ? extraConfigs || opt2 ? extraConfigs) {
            extraConfigs = opt1.extraConfigs or [] ++ opt2.extraConfigs or [];
          }
        // optionalAttrs (opt1 ? extraArgs || opt2 ? extraArgs) {
            extraArgs = opt1.extraArgs or {} // opt2.extraArgs or {};
          }
        // optionalAttrs (opt1 ? individualExtraArgs || opt2 ? individualExtraArgs) {
            individualExtraArgs = zipAttrsWith (name: values:
              if length values == 1 then head values else (head values // (head (tail values)))
            ) [ (opt1.individualExtraArgs or {}) (opt2.individualExtraArgs or {}) ];
          }
      )) {} opts;

  
  # !!! This function will be removed because this can be done with the
  # multiple option declarations.
  addDefaultOptionValues = defs: opts: opts //
    builtins.listToAttrs (map (defName:
      { name = defName;
        value = 
          let
            defValue = builtins.getAttr defName defs;
            optValue = builtins.getAttr defName opts;
          in
          if isOption defValue
          then
            # `defValue' is an option.
            if hasAttr defName opts
            then builtins.getAttr defName opts
            else defValue.default
          else
            # `defValue' is an attribute set containing options.
            # So recurse.
            if hasAttr defName opts && isAttrs optValue 
            then addDefaultOptionValues defValue optValue
            else addDefaultOptionValues defValue {};
      }
    ) (attrNames defs));

  mergeDefaultOption = list:
=======
  mergeDefaultOption = loc: defs:
    let list = getValues defs; in
>>>>>>> refs/top-bases/experimental/marc
    if length list == 1 then head list
    else if all builtins.isFunction list then x: mergeDefaultOption loc (map (f: f x) list)
    else if all isList list then concatLists list
    else if all isAttrs list then fold lib.mergeAttrs {} list
    else if all builtins.isBool list then fold lib.or false list
    else if all builtins.isString list then lib.concatStrings list
    else if all builtins.isInt list && all (x: x == head list) list then head list
    else throw "Cannot merge definitions of `${showOption loc}' given in ${showFiles (getFiles defs)}.";

  /* Obsolete, will remove soon.  Specify an option type or apply
     function instead.  */
  mergeTypedOption = typeName: predicate: merge: loc: list:
    let list' = map (x: x.value) list; in
    if all predicate list then merge list'
    else throw "Expected a ${typeName}.";

  mergeEnableOption = mergeTypedOption "boolean"
    (x: true == x || false == x) (fold lib.or false);

  mergeListOption = mergeTypedOption "list" isList concatLists;

  mergeStringOption = mergeTypedOption "string" builtins.isString lib.concatStrings;

  mergeOneOption = loc: defs:
    if defs == [] then abort "This case should never happen."
    else if length defs != 1 then
      throw "The unique option `${showOption loc}' is defined multiple times, in ${showFiles (getFiles defs)}."
    else (head defs).value;

  getValues = map (x: x.value);
  getFiles = map (x: x.file);


  # Generate documentation template from the list of option declaration like
  # the set generated with filterOptionSets.
  optionAttrSetToDocList = optionAttrSetToDocList' [];

  optionAttrSetToDocList' = prefix: options:
    fold (opt: rest:
      let
        docOption = rec {
          name = showOption opt.loc;
          description = opt.description or (throw "Option `${name}' has no description.");
          declarations = filter (x: x != unknownModule) opt.declarations;
          internal = opt.internal or false;
          visible = opt.visible or true;
        }
        // optionalAttrs (opt ? example) { example = scrubOptionValue opt.example; }
        // optionalAttrs (opt ? default) { default = scrubOptionValue opt.default; }
        // optionalAttrs (opt ? defaultText) { default = opt.defaultText; };

        subOptions =
          let ss = opt.type.getSubOptions opt.loc;
          in if ss != {} then optionAttrSetToDocList' opt.loc ss else [];
      in
        # FIXME: expensive, O(n^2)
        [ docOption ] ++ subOptions ++ rest) [] (collect isOption options);


  /* This function recursively removes all derivation attributes from
     `x' except for the `name' attribute.  This is to make the
     generation of `options.xml' much more efficient: the XML
     representation of derivations is very large (on the order of
     megabytes) and is not actually used by the manual generator. */
  scrubOptionValue = x:
    if isDerivation x then
      { type = "derivation"; drvPath = x.name; outPath = x.name; name = x.name; }
    else if isList x then map scrubOptionValue x
    else if isAttrs x then mapAttrs (n: v: scrubOptionValue v) (removeAttrs x ["_args"])
    else x;


  /* For use in the ‘example’ option attribute.  It causes the given
     text to be included verbatim in documentation.  This is necessary
     for example values that are not simple values, e.g.,
     functions. */
  literalExample = text: { _type = "literalExample"; inherit text; };


  /* Helper functions. */
  showOption = concatStringsSep ".";
  showFiles = files: concatStringsSep " and " (map (f: "`${f}'") files);
  unknownModule = "<unknown-file>";

}
