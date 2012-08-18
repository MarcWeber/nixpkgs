let inherit (builtins) add; in
with import ./default.nix;

runTests {

  testId = {
    expr = id 1;
    expected = 1;
  };
  
  testConst = {
    expr = const 2 3;
    expected = 2;
  };

  /*
  testOr = {
    expr = or true false;
    expected = true;
  };
  */
  
  testAnd = {
    expr = and true false;
    expected = false;
  };
  
  testFix = {
    expr = fix (x: {a = if x ? a then "a" else "b";});
    expected = {a = "a";};
  };

  testConcatMapStrings = {
    expr = concatMapStrings (x: x + ";") ["a" "b" "c"];
    expected = "a;b;c;";
  };

  testConcatStringsSep = {
    expr = concatStringsSep "," ["a" "b" "c"];
    expected = "a,b,c";
  };

  testFilter = {
    expr = filter (x: x != "a") ["a" "b" "c" "a"];
    expected = ["b" "c"];
  };

  testFold = {
    expr = fold (builtins.add) 0 (range 0 100);
    expected = 5050;
  };

  testEqStrict = {
    expr = all id [
      (eqStrict 2 2)
      (!eqStrict 3 2)
      (eqStrict [2 1] [2 1])
      (!eqStrict [1 3] [1 2])
      (eqStrict {a = 7; b = 20;} {b= 20; a = 7;})
      (eqStrict [{a = 7; b = 20;}] [{b= 20; a = 7;}])
      (eqStrict {a = [7 8]; b = 20;} {b= 20; a = [7 8];})
    ];
    expected = true;
  };

  testTake = testAllTrue [
    ([] == (take 0 [  1 2 3 ]))
    ([1] == (take 1 [  1 2 3 ]))
    ([ 1 2 ] == (take 2 [  1 2 3 ]))
    ([ 1 2 3 ] == (take 3 [  1 2 3 ]))
    ([ 1 2 3 ] == (take 4 [  1 2 3 ]))
  ];


  testOverridableDelayableArgsTest = {
    expr = 
      let res1 = defaultOverridableDelayableArgs id {};
          res2 = defaultOverridableDelayableArgs id { a = 7; };
          res3 = let x = defaultOverridableDelayableArgs id { a = 7; };
                 in (x.merge) { b = 10; };
          res4 = let x = defaultOverridableDelayableArgs id { a = 7; };
                in (x.merge) ( x: { b = 10; });
          res5 = let x = defaultOverridableDelayableArgs id { a = 7; };
                in (x.merge) ( x: { a = add x.a 3; });
          res6 = let x = defaultOverridableDelayableArgs id { a = 7; mergeAttrBy = { a = add; }; };
                     y = x.merge {};
                in (y.merge) { a = 10; };

          resRem7 = res6.replace (a : removeAttrs a ["a"]);

          resReplace6 = let x = defaultOverridableDelayableArgs id { a = 7; mergeAttrBy = { a = add; }; };
                            x2 = x.merge { a = 20; }; # now we have 27
                        in (x2.replace) { a = 10; }; # and override the value by 10

          # fixed tests (delayed args): (when using them add some comments, please)
          resFixed1 = 
                let x = defaultOverridableDelayableArgs id ( x : { a = 7; c = x.fixed.b; });
                    y = x.merge (x : { name = "name-${builtins.toString x.fixed.c}"; });
                in (y.merge) { b = 10; };
          strip = attrs : removeAttrs attrs ["merge" "replace"];
      in all id
        [ (eqStrict (strip res1) { })
          (eqStrict (strip res2) { a = 7; })
          (eqStrict (strip res3) { a = 7; b = 10; })
          (eqStrict (strip res4) { a = 7; b = 10; })
          (eqStrict (strip res5) { a = 10; })
          (eqStrict (strip res6) { a = 17; })
          (eqStrict (strip resRem7) {})
          (eqStrict (strip resFixed1) { a = 7; b = 10; c =10; name = "name-10"; })
        ];
    expected = true;
  };

  testsToRun = ["testEvalConfigOptions"];

  testEvalConfigOptions = 
    let eC = (import modules-2/eval-config.nix).evalConfig;
        pkgs = import /etc/nixos/nixpkgs/default.nix { };

        moduleFun = modulePath: module:
          {
            inherit modulePath;
            moduleOuterFun = { lib, ... }: {
               require  = []; # list like modulePathList
               inherit module;
            };
          };

        # simple module having int option
        intOptionModule = moduleFun "int-option" ({lib, ...}: { options.simpleIntValue = lib.mkOptionSingle { description = "simple int value"; }; });
        # module defining that int value
        intConfigModule = moduleFun "int-config" ({lib, ...}: { config .simpleIntValue = 10; });

        # test that mkMerge works on values (should also work on option/config attr trees)
        intOptionListModule1 = moduleFun "int-list-option" ({lib, ...}: {
            options.intValues = lib.mkOption { description = "simple int values"; };
            config .intValues = lib.mkMerge [ 10 20 ];# due to mkMerge you can pass many configuration values in one concfiguration setting
        });

        # however more appropriate may be the mkOptionList option:
        intOptionListModule2 = moduleFun "int-list-option" ({lib, ...}: {
            options.intValues = lib.mkOptionList { option = lib.mkOption { description = "simple int values"; type = lib.types.int; }; };
            config .intValues = [ 10 20 ];
        });

        intOverrideConfigModule = moduleFun "int-override-config" ({lib, ...}: { config .simpleIntValue = lib.mkOverride 1 50; });

        u = nr: { name1 = "u${builtins.toString nr}_name_1"; name2 = "u${builtins.toString nr}_name_2"; };

        referToModule = moduleFun "referToModule" ({lib, config, ...}: {
            options = {
              option1 = lib.mkOptionSingle { description = "option1"; };
              option2 = lib.mkOptionSingle { description = "option2"; };
            };
            config.option2 = 20;
            config.option1 = config.option2;
        });

        optionAttrListTest = moduleFun "optionAttrListTest" ({lib, config, ...}: {
            options =
            let userOption = {
                name1 = lib.mkOptionSingle { description = "first name"; };
                name2 = lib.mkOptionSingle { description = "first name"; };
            };
            in
            {
              attrOption = lib.mkOptionAttrs { option = userOption; };
              listOption = lib.mkOptionList { option = userOption; };
            };
            config.attrOption.first_user  = u 1;
            config.attrOption.second_user = u 2;
            config.listOption = [ (u 1) (u 2) ];
        });

        # note: even though this is possible I don't recommend it:
        crazyModuleCreatingOption = moduleFun "crazy-module-creating-option" ({lib, config, ...}: lib.mkMerge [
            # option providing name
            { options.optionName = lib.mkOptionSingle { description = "option name"; }; }
            # generated option
            { options.generated = 
               let name = config.optionName;
                in builtins.listToAttrs [ { inherit name; value = lib.mkOptionSingle { description = "generated option ${name}"; }; } ];
            }
            {
              config = {
                # setting name
                optionName = "foobar";
                # setting generated option
                generated.foobar = 10;
              };
            }
        ]);

    in {
      expr = {
        test_mkOverride 
          = (eC { inherit pkgs; modulePathList = [ intOptionModule intConfigModule intOverrideConfigModule ]; }).simpleIntValue;

        test_refer_to_option_same_level
          = (eC { inherit pkgs; modulePathList = [ referToModule ]; }).option1;

        test_option_attr_list
          = (eC { inherit pkgs; modulePathList = [ optionAttrListTest ]; });

        test_crazy_dynamic_option
          = (eC { inherit pkgs; modulePathList = [ crazyModuleCreatingOption ]; }).generated.foobar;

        test_int_values1
          = (eC { inherit pkgs; modulePathList = [ intOptionListModule1 ];}).intValues;

        test_int_values2
          = (eC { inherit pkgs; modulePathList = [ intOptionListModule2 ];}).intValues;

      };

      expected = {
        test_mkOverride = 50;
        test_refer_to_option_same_level = 20;
        test_option_attr_list = {
          attrOption.first_user = (u 1);
          attrOption.second_user = (u 2);
          listOption = [ (u 1) (u 2) ];
        };
        test_crazy_dynamic_option = 10;

        test_int_values1 = [ 10 20 ];
        test_int_values2 = [ 10 20 ];
      };
    };
  
}
