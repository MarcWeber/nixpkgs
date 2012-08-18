/*
interface: pretty similar to what Nicolas Pierron did
Difference: 
- minimalistic implementation using higher order functions when possible
- no more to use mkElse in insane ways


high level overview: What is a module?
======================================

{ lib # the pkgs.lib with some mkOption like special functions
, ...
{
  require = [ list see modulePathList below ];

  module = { pkgs
            , config
            , lib
            , ...} : {

    # tree of options fo each module - not sure wether it should depend on config argument
    # because I'm not sure I'll keep in within this function but I'll add a check
    options = 

    # tree of config settings for each module
    config = 
  }

}

opten declarations: nested dictionaries. Special keys:
type_option: This name defines current node to be an option declaration.
type_option_attrs: This name defines current node to be attribute set option declaration
                   attribute sets allow many configurations of the same type
                   assigned to attribute names (eg Upstart jobs)
type_option_list:  This node defines current node to be a list set option declaration.
                   Same for lists.


TODO:
  type list allowed adding config section
  mkAssert!
*/


let 

  evalConfig = {
      # list of either:
      #  {
      #    modulePath =  "a string identifying this module";
      #    moduleOuterFun = { lib, ... }: {
      #       require  = []; # list like modulePathList
      #       module = {pkgs, config, options , ... }: {
      #        options.foo = mkOptionSingle { description = "simple int"; };
      #        config.foo = 7;
      #       }
      #    }
      #  }
      # or 
      #  path to file containing an moduleOuterFun.
      # 
      modulePathList
    , # initial pkgs providing lib etc
      pkgs
    , checkOptions ? true
    }:
    let 
      inherit (pkgs) lib;
      inherit (lib) fold mapAttrs maybeAttr filter concatMap mergeAttrs
      concatLists concatMapStrings concatStringsSep attrValues;
      inherit (builtins) head tail isList isString isAttrs listToAttrs hasAttr getAttr attrNames lessThan;

      # keep elements of list items having highest override level.
      processOverrides = list: acc: currLevel:
        if list == [] then acc
        else
          let h = head list;
              t = tail list;
              is_overr = isAttrs h.value && h.value ? type_override;
              l = if is_overr then h.value.level else 0;
              v = if is_overr then mmap (x: x.type_override) h else h;
          in 
              if currLevel == l               then processOverrides t (acc ++ [v]) currLevel
              else if lessThan l currLevel    then processOverrides t (acc) currLevel
              else /* lessThan currLevel l */      processOverrides t ([v]) l;

      ### functions intended to be used by the user exposed by libWithExtras

      /* mkMerge allows you to define multiple values within a single module
       * for a given path in a tree. Example:
       *   module 1:  { a.b.c = 1; }
       *   module 2:  { a.b.c = 2; }
       * can be written as:
       *   one module:{ a.b.c = mkMerge [1 2]; }
       * Eg VirtualBox guest / host support can be implemented within one module:
       * {
       *    options.virtualbox.enable = "guest or host";
       *    config = mkMerge (
       *      (lib.optional config.virtualbox == "host" {
       *          # settings for host
       *      })
       *      (lib.optional config.virtualbox == "guest" {
       *          # settings for guest
       *      })
       *    );
       * }
       */
      mkMerge = list: assert isList list; { type_merge = list; };

      # for compatibility - may go away
      mkAssert= p: m: v:
        if !p then throw m
        else v;

      mkIf = p: a: mkMerge (lib.optional p a);

      mkIfElse = p: if_: else_:
        mkMerge (
               (lib.optional p if_)
            ++ (lib.optional (! p) else_)
        );

      mkOverride = level: value: {
        inherit level;
        type_override = value;
      };


      mergeFunSingle = xs: if tail xs != [] then throw "option must be set once at most!"
                         else head xs;

      types = {
        int = {
          mergeFun = mergeFunSingle;
          checkItemFun = builtins.isInt;
        };
        string = {
          mergeFun = mergeFunSingle;
          checkItemFun = builtins.isString;
        };
        once = {
          mergeFun = mergeFunSingle;
        };
        shellCode = shells: {
          mergeFun = pkgs.lib.mergeShellCode shells;
          # checkItemFun TODO
        };
        # should be renamed to bool_any_true or such
        bool = {
          check = lib.traceValIfNot builtins.isBool;
          mergeFun = fold lib.or false; # ?
        };
      };

      libWithExtras = lib // rec {
        inherit mkMerge mkAssert mkIf mkIfElse mkOverride types;

        # shortcut for modules without dependencies
        moduleNoDeps = module:
          { lib # the pkgs.lib with some mkOption like special functions
          , ...
          }:
          { require = []; inherit module; };

        # basic function creating an option
        # mandatory names:
        #   description
        # optional names:
        #   default
        #   checkItemFun
        #   mergeFun
        #   type
        mkOption = option:
          let 
              # can be used to check each elemnt before folding option elements
              # must return string error message if check fails
              # true: value ok
              # everything else indicates bad type
              checkItemFun = lib.maybeAttr "checkItemFun" (x: true) option;

              # eg lib.concatStringsSep "\n" for scripts
              mergeFun  = 
                    # pierrons options support merge instead mergeFun
                let compatibility = lib.maybeAttr "merge" (xs: xs) option;
                in lib.maybeAttr "mergeFun" compatibility option;

          in

          {
            type_option = {path ? [], modulePath}: 
            let opt =
                option  # args description and default are merged into the result here:
                   // { inherit checkItemFun mergeFun path modulePath; }
                   // (if option ? type then option.type else {});
            in opt // {
                yield = list: 
                  if list == [] then
                    if option ? default
                      then option.default
                      else throw "option ${pathToStr path} defined in ${modulePath} requires default value or must be set!"
                    else
                      lib.addErrorContext "while evaluating option ${pathToStr path}"
                      ( opt.mergeFun (map (x: 
                                           let err = opt.checkItemFun x.value;
                                           in if err == true
                                              then x.value 
                                              else throw "bad value for ${pathToStr path} defined in ${x.modulePath} err: ${lib.traceXMLVal err}"
                                      )
                                      (processOverrides list [] 0)));
            };
          };

        # same as mkOption but allows this option to be set once only
        mkOptionSingle = option: mkOption ( option // {
          mergeFun = xs: if tail xs != [] then throw "option must be set once at most!"
                         else head xs;
        });

        # mkOption with default mergeFun
        mkOptionScript = option: mkOption (option // {
          mergeFun = concatStringsSep "\n";
        });

        # .*. in documentation:
        # mkOptionAttrs attrs whose value are of type option
        mkOptionAttrs = a@{
            # same as module.options
            option ? {}
            # ,
            # if two different paths (such as configuration.nix and a module) define options.jobs.upstart =  { .. }
            # merge_options_different_paths ? false
        }: { 
          type_option_attrs = option;
        };

        # mkOptionAttrs list whose value are of type option
        mkOptionList = x@{option ? []}: { type_option_list = option; };

      };

      ### END functions intended to be used by the user exposed by libWithExtras

      ### helper functions

      # wrap value by attrs containing modulePath
      mmap = f: m: {value = f m.value; inherit (m) modulePath; };
      mvalue = x: x.value;

      pathToStr = lib.concatStringsSep ".";
      # flatten [ i1(w) { type_merge = [i2 i3] }{w} ] to [i1(w) i2(w) i3(w)] where (w) means wrapped by modulePath
      flattenMerges = list: 
        fold (new: l: if new.value ? type_merge
                      then l ++ (map (x: {inherit (new) modulePath; value = x;}) new.value.type_merge)
                      else l ++ [ new ]) [] list;


      # return attrs as list
      getAttrs = attr: list: flattenMerges (concatMap (a: 
                  if hasAttr attr a.value 
                  then [ { inherit (a) modulePath; value = getAttr attr a.value; }]
                  else []
                  ) list);

      # for each attr name found in any attrs in attrList
      # pass values as list to f and assign it to the name
      traverseListOfAttrs = f: attrList:
        listToAttrs (map (name:
            let values = getAttrs name attrList;
            in { inherit name; value = f name values; }
        ) # all attrs:
          (attrNames (fold mergeAttrs {} (map mvalue attrList))));

      ### merging options. The result is used by mergeConfigs and can be used to create documentation
      mergeOptions = path: optionList:
        let optionDecls = filter (x: x.value ? type_option) optionList;
            optionAttrDecls = filter (x: x.value ? type_option_attrs) optionList;
            optionListDecls = filter (x: x.value ? type_option_list) optionList;

            declError = msg: "option declaration error: ${pathToStr path} defined in ${lib.concatStringsSep ", " (map (x: x.value) optionDecls)}: ${msg}";

            mergeDecls = 
                if tail optionDecls == []
                  then
                    # return leaf
                    let h = head optionDecls;
                        option = h.value.type_option {
                              inherit path;
                              inherit (h) modulePath;
                          };
                    in # pass path and defining module path to option function:
                       if option ? description
                       then { type_option = option; }
                       else throw "option ${pathToStr path} has no description! ${builtins.toXML option}"
                  else declError "multiple modules define the same option!";

            mergeAttrDecls = 
              if tail optionAttrDecls == []
                then
                  let h = head optionAttrDecls;
                  in {
                    type_option_attrs = mergeOptions path [{ value = h.value.type_option_attrs; inherit (h) modulePath; }];
                  }
                  
              else declError "multiple modules define an option attribute declaration!";

            mergeListDecls =
              if tail optionListDecls == []
                then
                  let h = head optionListDecls;
                  in {
                    type_option_list = mergeOptions path [{ value = h.value.type_option_list; inherit (h) modulePath; }];
                  }
                  
              else declError "multiple modules define an option attribute declaration!";

        in
        # if no list element has .type_{option,option_attrs,option_list}
        # its not an option, thus traverse - yes this means that you can't use type_*
        # as name in an option value
        if optionDecls ++ optionAttrDecls ++ optionListDecls == [] 
          then 
          # no option defined, traverse tree
          traverseListOfAttrs (name: mergeOptions (path ++ [name])) optionList
        # options defined only
        else if optionAttrDecls ++ optionListDecls == [] then mergeDecls
        # merge attr only
        else if optionDecls     ++ optionListDecls == [] then mergeAttrDecls
        # merge lists only
        else if optionDecls     ++ optionAttrDecls == [] then mergeListDecls
        # everything else is unexpected
        else declError "different option types defined for ${pathToStr path}";

      ### merging configs (checking against option tree)
      # option: the node returned by mergeOptions
      # attrList: the items of this list are the config values defined in modules
      mergeConfigs = path: option: attrList:
        let recurseAttr = optionDeclAttr: mapAttrs (name: value: mergeConfigs (path ++ [name]) value (getAttrs name attrList) ) optionDeclAttr;
        in

        if option ? type_option
        then # option declaration. merge config values
          # handle overrides (TODO)
          option.type_option.yield attrList

        else if option ? type_option_attrs
          then 
            # recurse
            let attrNames = lib.attrNames (fold (a: b: a.value // b ) {} attrList);
                # for each name being used in config create option name and the name's value being the option declaration
            in  recurseAttr (listToAttrs (map (name: {inherit name; value = option.type_option_attrs; }) attrNames))

        else if option ? type_option_list then

          let liftModulePath = a: map (x: { modulePath = a.modulePath; value = x; }) a.value;
              l = lib.concatMap liftModulePath attrList;
          in map (v: mergeConfigs (path ++ ["list-index"]) option.type_option_list [v]) l

        else # check for config options without option declaration, then recurse
          let followNames = attrNames option;

              checkList = path: list: 
                (concatLists (filter isList (attrValues (traverseListOfAttrs (configValuesWithoutOptionDecl path) list))));
  
              # names without option declaration
              configValuesWithoutOptionDecl = path: (name: list:
                    let
                        # {} could be an option - treat it as empty node. Everything else is a config option without option declaration => return error
                        checkNode = item: if isAttrs item.value then item else "${pathToStr path} in ${item.modulePath}";
                        checked = map checkNode list;
                        errors = filter isString checked;
                    in if errors == []
                        then
                          # recurse tree wihtout option decls:
                          checkList (path ++ [name]) checked
                        else errors
                );

              errMsg = x: if x.value == {} then []
                else ["config options ${pathToStr path}.{${lib.concatStringsSep "," (attrNames x.value)}} set in ${x.modulePath} without option declaration"];
              bad = concatMap (c: errMsg (mmap (x: builtins.removeAttrs x followNames) c)) attrList;

          in if !checkOptions || bad == []
             then # recurse
                  recurseAttr option # same line above
             else throw "config values without option declaration: ${concatMapStrings (x: "\n - ${x}") bad}";


      # recursively load modules following require fields
      moduleFuns = seenPathList: modules: paths:
        if paths == [] then modules
        else let
                h = head paths;
                t = tail paths;
                module_attr = if isAttrs h 
                    then h # h should already be module function
                    else {
                      modulePath = h;
                      moduleOuterFun = (import h);
                    };
                 outer = module_attr.moduleOuterFun { lib = libWithExtras; };
                 m = { inherit (module_attr) modulePath; value = outer.module; };
              in
              if lib.elem m.modulePath seenPathList
                then  # skip known module
                      moduleFuns seenPathList          modules t 
                else  # load module, wrap by modulePath so that location info can be given if something goes wrong
                      # continue visiting unseen paths
                     moduleFuns (seenPathList ++ [m.modulePath]) (modules ++ [m]) (t ++ maybeAttr "require" [] outer);
    in

      (
        # the main code doing all the merge work ..
        pkgs.lib.fix (fixed:
              let 
                applyModuleArgs = config: f: f {
                  inherit pkgs;
                  inherit (fixed) options; # passing options so that manual can be generated
                  inherit (fixed) config;
                  lib = libWithExtras;

                };
                moduleList = flattenMerges (map (mmap (applyModuleArgs fixed.config))
                                                                 (moduleFuns [] [] modulePathList)
                                                            );
              in rec {
                # the result of merged configs
                options = mergeOptions [] (getAttrs "options" moduleList);
                config  = mergeConfigs [] options (getAttrs "config"  moduleList);
              }
        )
      ).config; # if you need options outside of this fix function assign it to a config value.
  in {
    inherit evalConfig;
}
