{ fetchurl, bash, stdenv, python, cmake, vim, vimUtils, perl, ruby, unzip,
  which, fetchgit, fetchhg, fetchzip, llvmPackages, zip, vim_configurable,
  vimPlugins
}:

let

inherit (vimUtils.override {inherit vim;}) rtpPath addRtp buildVimPluginFrom2Nix vimHelpTags;

in

rec {
  inherit rtpPath;
  # only the plugins Marc Weber is using

  "Colour_Sampler_Pack" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "Colour_Sampler_Pack";
    src = fetchurl {
      url = "http://www.vim.org/scripts/download_script.php?src_id=18915";
      name = "ColorSamplerPack.zip";
      sha256 = "1wsrb3vpqn9fncnalfpvc8r92wk1mcskm4shb3s2h9x5dyihf2rd";
    };
    buildInputs = [ unzip ];
    dependencies = [];
    meta = {
       url = "http://www.vim.org/scripts/script.php?script_id=625";
    };
  };
  "Gist" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "Gist";
    src = fetchgit {
      url = "git://github.com/mattn/gist-vim";
      rev = "d609d93472db9cf45bd701bebe51adc356631547";
      sha256 = "e5cabc03d5015c589a32f11c654ab9fbd1e91d26ba01f4b737685be81852c511";
    };
    dependencies = [];
  };
  "Gundo" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "Gundo";
    src = fetchhg {
      url = "https://bitbucket.org/sjl/gundo.vim";
      rev = "eb9fc8676b89";
      sha256 = "05lcxrd9ibfi02ja4jvl5y5pp884b8kh9aarw045b0mlldygv6cp";
    };
    dependencies = [];
  };
  "Hoogle" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "Hoogle";
    src = fetchgit {
      url = "git://github.com/Twinside/vim-hoogle";
      rev = "81f28318b0d4174984c33df99db7752891c5c4e9";
      sha256 = "0f96f3badb6218cac87d0f7027ff032ecc74f08ad3ada542898278ce11cbd5a0";
    };
    dependencies = [];
  };
  "Solarized" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "Solarized";
    src = fetchgit {
      url = "git://github.com/altercation/vim-colors-solarized";
      rev = "528a59f26d12278698bb946f8fb82a63711eec21";
      sha256 = "a1b2ef696eee94dafa76431c31ee260acdd13a7cf87939f27eca431d5aa5a315";
    };
    dependencies = [];
  };
  "Supertab" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "Supertab";
    src = fetchgit {
      url = "git://github.com/ervandew/supertab";
      rev = "b0ca47f4570385043f270f9278ba6d50d1d2fa00";
      sha256 = "24e3e63096a6b6f7f00d985ae6f31377154566d6483fb81572a474053fa43082";
    };
    dependencies = [];
  };
  "Syntastic" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "Syntastic";
    src = fetchgit {
      url = "git://github.com/scrooloose/syntastic";
      rev = "67ffe58818930e95163ead541a2700cec41c13f7";
      sha256 = "b28286f5045e12392aaee08be7301707af16d343b391da4a2a2048a0ed4aa754";
    };
    dependencies = [];
  };
  "Tabular" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "Tabular";
    src = fetchgit {
      url = "git://github.com/godlygeek/tabular";
      rev = "60f25648814f0695eeb6c1040d97adca93c4e0bb";
      sha256 = "28c860ad621587f2c3213fae47d1a3997746527c17d51e9ab94c209eb7bfeb0f";
    };
    dependencies = [];
  };
  "Tagbar" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "Tagbar";
    src = fetchgit {
      url = "git://github.com/majutsushi/tagbar";
      rev = "f9c5f24576e82aae5ab8a5480f1ae48615354e40";
      sha256 = "e1ff486f27c0980fee959db69da5617c4653910504b20aeabe87037a8b68712a";
    };
    dependencies = [];
  };
  "The_NERD_Commenter" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "The_NERD_Commenter";
    src = fetchgit {
      url = "git://github.com/scrooloose/nerdcommenter";
      rev = "6549cfde45339bd4f711504196ff3e8b766ef5e6";
      sha256 = "ef270ae5617237d68b3d618068e758af8ffd8d3ba27a3799149f7a106cfd178e";
    };
    dependencies = [];
  };
  "The_NERD_tree" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "The_NERD_tree";
    src = fetchgit {
      url = "git://github.com/scrooloose/nerdtree";
      rev = "3b98a7fcae8f9fff356907171f0406ff8cd28921";
      sha256 = "deec2ce33249829ae3925478d7d1925ea99e20c37dcc86db7c3bfac4fdc706e0";
    };
    dependencies = [];
  };
  "UltiSnips" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "UltiSnips";
    src = fetchgit {
      url = "git://github.com/sirver/ultisnips";
      rev = "6907b2444c6d5b1af50e64665634683ea71480c1";
      sha256 = "27d06628b120e8b445ddcd69d31c7d9d2d60ebfa16a0f2679e8cd5b4aea7f2e3";
    };
    dependencies = [];
  };
  "VimOutliner" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "VimOutliner";
    src = fetchgit {
      url = "git://github.com/vimoutliner/vimoutliner";
      rev = "469f49b5f28bc2b838a80568c9413f690cc3ffb6";
      sha256 = "38f88f9bbc43622809404c0054a7a4e9b2214166f3b2784511e4fda05bcb4713";
    };
    dependencies = [];
  };
  "WebAPI" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "WebAPI";
    src = fetchgit {
      url = "git://github.com/mattn/webapi-vim";
      rev = "a7789abffe936db56e3152e23733847f94755753";
      sha256 = "455b84d9fd13200ff5ced5d796075f434a7fb9c00f506769174579266ae2be80";
    };
    dependencies = [];
  };
  "YankRing" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "YankRing";
    src = fetchurl {
      url = "http://www.vim.org/scripts/download_script.php?src_id=20842";
      name = "yankring_180.zip";
      sha256 = "0bsq4pxagy12jqxzs7gcf25k5ahwif13ayb9k8clyhm0jjdkf0la";
    };
    buildInputs = [ unzip ];
    dependencies = [];
    meta = {
       url = "http://www.vim.org/scripts/script.php?script_id=1234";
    };
  };
  "commentary" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "commentary";
    src = fetchgit {
      url = "git://github.com/tpope/vim-commentary";
      rev = "9c685131a5facfa0d643feca3a61b41c007d8170";
      sha256 = "2a9f394d0669429469c2f1ddaf9a722c2773f35da08ea9496d3b4b4e85b6038d";
    };
    dependencies = [];
  };
  "ctrlp" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "ctrlp";
    src = fetchgit {
      url = "git://github.com/kien/ctrlp.vim";
      rev = "b5d3fe66a58a13d2ff8b6391f4387608496a030f";
      sha256 = "41f7884973770552395b96f8693da70999dc815462d4018c560d3ff6be462e76";
    };
    dependencies = [];
  };
  "extradite" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "extradite";
    src = fetchgit {
      url = "git://github.com/int3/vim-extradite";
      rev = "af4f3a51b6b654d655121b93c0cd9d8fe9a0c85d";
      sha256 = "d1d29cfbc654134be383747f2cd6b14b7a87de75f997af6a041f14d7ef61ade6";
    };
    dependencies = [];
  };
  "fugitive" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "fugitive";
    src = fetchgit {
      url = "git://github.com/tpope/vim-fugitive";
      rev = "2c8461db084d205903a792a23163faa546f143c9";
      sha256 = "c2569877958fcc5d181cc5b9e26d6b0b022c30aa9ce0908dd96131b44eb90729";
    };
    dependencies = [];
  };
  "ghcmod" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "ghcmod";
    src = fetchgit {
      url = "git://github.com/eagletmt/ghcmod-vim";
      rev = "d5c6c7f3c85608b5b76dc3e7e001f60b86c32cb9";
      sha256 = "ab56d470ea18da3fae021e22bba14460505e61a94f8bf707778dff5eec51cd6d";
    };
    dependencies = [];
  };
  "github_MarcWeber" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "github:MarcWeber";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-MarcWeber";
      rev = "7de7c66bab0578714db5a4f5ef8e4d7fdff33b20";
      sha256 = "49c2065bd7dc408e96eb1cdda4b23f6bf05165decab470d227f4eae71e181428";
    };
    dependencies = [];
  };
  "matchit.zip" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "matchit.zip";
    src = fetchurl {
      url = "http://www.vim.org/scripts/download_script.php?src_id=8196";
      name = "matchit.zip";
      sha256 = "1bbm8j1bhb70kagwdimwy9vcvlrz9ax5bk2a7wrmn4cy87f9xj4l";
    };
    buildInputs = [ unzip ];
    dependencies = [];
    meta = {
       url = "http://www.vim.org/scripts/script.php?script_id=39";
    };
  };
  "openscad" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "openscad";
    src = fetchgit {
      url = "git://github.com/sirtaj/vim-openscad";
      rev = "7868a38c6c1f243092c98e46b77baf9fa5f55727";
      sha256 = "24d397a2554ebe225f3d395d97fc67d378cc350e56403d76efbc1f81d822901c";
    };
    dependencies = [];
  };
  "pathogen" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "pathogen";
    src = fetchgit {
      url = "git://github.com/tpope/vim-pathogen";
      rev = "b9fb0dfd811004010f5f6903edef42d6004ebea2";
      sha256 = "62ec7e9721651aa86aa716d47c2057771f7d093f414c3b98f50a759d210db4c7";
    };
    dependencies = [];
  };
  "phpcomplete" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "phpcomplete";
    src = fetchgit {
      url = "git://github.com/shawncplus/phpcomplete.vim";
      rev = "1fffeb24407e93298680dbb1c077736db1fa0f4b";
      sha256 = "6b8fbe0d40ca0cb1d59fcce061ddd139f510d081c85e40e132b442f214b1d773";
    };
    dependencies = [];
  };
  "quickfixstatus" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "quickfixstatus";
    src = fetchgit {
      url = "git://github.com/dannyob/quickfixstatus";
      rev = "fd3875b914fc51bbefefa8c4995588c088163053";
      sha256 = "7b6831d5da1c23d95f3158c67e4376d32c2f62ab2e30d02d3f3e14dcfd867d9b";
    };
    dependencies = [];
  };
  "rainbow_parentheses" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "rainbow_parentheses";
    src = fetchgit {
      url = "git://github.com/kien/rainbow_parentheses.vim";
      rev = "eb8baa5428bde10ecc1cb14eed1d6e16f5f24695";
      sha256 = "47975a426d06f41811882691d8a51f32bc72f590477ed52b298660486b2488e3";
    };
    dependencies = [];
  };
  "reload" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "reload";
    src = fetchgit {
      url = "git://github.com/xolox/vim-reload";
      rev = "0a601a668727f5b675cb1ddc19f6861f3f7ab9e1";
      sha256 = "c4437328b1f3940beb60abeaecedb681aa5204c0e98b445c351e3c8fa15a61af";
    };
    dependencies = [];
  };
  "rust" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "rust";
    src = fetchgit {
      url = "git://github.com/wting/rust.vim";
      rev = "0fd423990cfa69336fb6c1d5d58aa2091e7b4e76";
      sha256 = "21f3decedb24478bc391152bf26a9b88d9e4fa5fcdbdb8a558d95b6bb7be2ff1";
    };
    dependencies = [];
  };
  "snipmate" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "snipmate";
    src = fetchgit {
      url = "git://github.com/garbas/vim-snipmate";
      rev = "8cb6c3ebe267873dc5abb9a36305c75d9564dea4";
      sha256 = "f4692709724a50ff14ccdd5692d90ebdb950417267adb2228f5ce6006471bad4";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];
  };
  "sourcemap.vim" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "sourcemap.vim";
    src = fetchgit {
      url = "git://github.com/chikatoike/sourcemap.vim";
      rev = "0dd82d40faea2fdb0771067f46c01deb41610ba1";
      sha256 = "a08c77aea39be4a0a980d62673d1d17fecc518a8aeb9101210e453aaacb78fbd";
    };
    dependencies = [];
  };
  "sparkup" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "sparkup";
    src = fetchgit {
      url = "git://github.com/chrisgeo/sparkup";
      rev = "6fbfceef890e705c47b42b27be743ffed6f9296e";
      sha256 = "495c0e2627ac510a7623d302e29788632259a1b80af341ec9cd81ae105aec03f";
    };
    dependencies = [];
  };
  "surround" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "surround";
    src = fetchgit {
      url = "git://github.com/tpope/vim-surround";
      rev = "fa433e0b7330753688f715f3be5d10dc480f20e5";
      sha256 = "5f01daf72d23fc065f4e4e8eac734275474f32bfa276a9d90ce0d20dfe24058d";
    };
    dependencies = [];
  };
  "table-mode" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "table-mode";
    src = fetchgit {
      url = "git://github.com/dhruvasagar/vim-table-mode";
      rev = "e1258702126463b30e32a8a4cd1ba28689a93ef8";
      sha256 = "2b8ac53a0a346f27db617dade3bd3e4da7d5b560a99c636da7d27cf5622a6690";
    };
    dependencies = [];
  };
  "textobj-rubyblock" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "textobj-rubyblock";
    src = fetchgit {
      url = "git://github.com/nelstrom/vim-textobj-rubyblock";
      rev = "b5b84e49e609439e81aa03fa8e605a6097185665";
      sha256 = "0473b47a7bec1b136b155dc414272a2492011b484eb7c08ea5dd08b957897f45";
    };
    dependencies = ["textobj-user"];
  };
  "textobj-user" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "textobj-user";
    src = fetchgit {
      url = "git://github.com/kana/vim-textobj-user";
      rev = "9aa5fd050ecce650fb7ff018397e73a66a41c76b";
      sha256 = "dc6b1742da1af505faa9db5daf6f18e66bb60758d004c1ac48f693adf4007346";
    };
    dependencies = [];
  };
  "tlib" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "tlib";
    src = fetchgit {
      url = "git://github.com/tomtom/tlib_vim";
      rev = "b730863d67f26e01868fee5a9a680a0c721bd44a";
      sha256 = "5a29bb88e0ede014d009f1a0e47182ca32dc759e0421b2c5dda6e950aafdb638";
    };
    dependencies = [];
  };
  "undotree" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "undotree";
    src = fetchgit {
      url = "git://github.com/mbbill/undotree";
      rev = "88e4a9bc2f7916f24441faf884853a01ba11d294";
      sha256 = "ad55b88db051f57d0c7ddc226a7b7778daab58fa67dc8ac1d78432c0e7d38520";
    };
    dependencies = [];
  };
  "vim-addon-actions" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-actions";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-actions";
      rev = "a5d20500fb8812958540cf17862bd73e7af64936";
      sha256 = "d2c3eb7a1f29e7233c6fcf3b02d07efebe8252d404ee593419ad399a5fdf6383";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];
  };
  "vim-addon-async" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-async";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-async";
      rev = "dadc96e188f1cdacbac62129eb29a1eacfed792c";
      sha256 = "27f941e21a8ca5940bd20914e2a9e3809e554f3ef2c27b3bafb9a153107a5d07";
    };
    dependencies = ["vim-addon-signs"];
  };
  "vim-addon-background-cmd" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-background-cmd";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-background-cmd";
      rev = "14df72660a95804a57c02b9ff0ae3198608e2491";
      sha256 = "5c2ece1f3ff7653eb7c1b40180554e8e89e5ae43d67e7cc159d95c0156135687";
    };
    dependencies = ["vim-addon-mw-utils"];
  };
  "vim-addon-commenting" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-commenting";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-commenting";
      rev = "b7cf748ac1c9bf555cbd347589e3b7196030d20b";
      sha256 = "4ad7d5f6669f0a1b4a24c9ce3649c030d7d3fc8588de4d4d6c3269140fbe9b3e";
    };
    dependencies = [];
  };
  "vim-addon-completion" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-completion";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-completion";
      rev = "80f717d68df5b0d7b32228229ddfd29c3e86e435";
      sha256 = "c8c0af8760f2622c4caef371482916861f68a850eb6a7cd746fe8c9ab405c859";
    };
    dependencies = ["tlib"];
  };
  "vim-addon-errorformats" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-errorformats";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-errorformats";
      rev = "dcbb203ad5f56e47e75fdee35bc92e2ba69e1d28";
      sha256 = "a1260206545d5ae17f2e6b3319f5cf1808b74e792979b1c6667d75974cc53f95";
    };
    dependencies = [];
  };
  "vim-addon-git" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-git";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-git";
      rev = "3d19ccc5b1add472ce96465fd8e7f5f173170569";
      sha256 = "31ae75870028f2b235409036c02dcd62cc60e33456b1f21a2bb30d2bcab9f1c8";
    };
    dependencies = ["vim-addon-goto-thing-at-cursor" "vim-addon-views" "vim-addon-mw-utils" "tlib"];
  };
  "vim-addon-goto-thing-at-cursor" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-goto-thing-at-cursor";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-goto-thing-at-cursor";
      rev = "f052e094bdb351829bf72ae3435af9042e09a6e4";
      sha256 = "34658ac99d9a630db9c544b3dfcd2c3df69afa5209e27558cc022b7afc2078ea";
    };
    dependencies = ["tlib"];
  };
  "vim-addon-haskell" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-haskell";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-haskell";
      rev = "3d9f6399debe33cb3f46a0d3e3dd1ae0162ed36b";
      sha256 = "543f1e3002ebbfc119d8b09430c4977357f21d6c6d0fd9b30f67dfdb83336b8b";
    };
    dependencies = ["vim-addon-background-cmd" "vim-addon-views" "vim-addon-actions" "vim-addon-mw-utils" "tlib"];
  };
  "vim-addon-json-encoding" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-json-encoding";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-json-encoding";
      rev = "0aba90c873742b52d020f3c889a37382552fad08";
      sha256 = "e6ab30c456af717f5f7dcb4a979d4375361ba05668d55be7b540417088a3590d";
    };
    dependencies = [];
  };
  "vim-addon-local-vimrc" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-local-vimrc";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-local-vimrc";
      rev = "7689b55ee86dd6046923fd28ceab49da3881abfe";
      sha256 = "f11d13676e2fdfcc9cabc991577f0b2e85909665b6f245aa02f21ff78d6a8556";
    };
    dependencies = [];
  };
  "vim-addon-manager" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-manager";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-manager";
      rev = "345c4b357843b14f4622f212e4d1e0e3f8a7f08a";
      sha256 = "d8fba7dd089f4a919f91dc284537880d7a841c26dacb503ea08b15dce35e7626";
    };
    dependencies = [];
  };
  "vim-addon-mru" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-mru";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-mru";
      rev = "e41e39bd9d1bf78ccfd8d5e1bc05ae5e1026c2bb";
      sha256 = "15b70f796f28cbd999060fea7f47408fa8a6cb176cd4915b9cc3dc6c53eed960";
    };
    dependencies = ["vim-addon-other" "vim-addon-mw-utils"];
  };
  "vim-addon-mw-utils" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-mw-utils";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-mw-utils";
      rev = "0c5612fa31ee434ba055e21c76f456244b3b5109";
      sha256 = "4e1b6d1b59050f1063e58ef4bee9e9603616ad184cd9ef7466d0ec3d8e22b91c";
    };
    dependencies = [];
  };
  "vim-addon-nix" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-nix";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-nix";
      rev = "7b0a376bb1797fef8da2dc14e768f318bcb671e8";
      sha256 = "c2b0f6f50083063b5e801b872f38d4f00307fe5d7a4f3977a108e5cd10c1c410";
    };
    dependencies = ["vim-addon-completion" "vim-addon-goto-thing-at-cursor" "vim-addon-errorformats" "vim-addon-actions" "vim-addon-mw-utils" "tlib"];
  };
  "vim-addon-other" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-other";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-other";
      rev = "f78720c9cb5bf871cabb13c7cbf94378dbf0163b";
      sha256 = "43f027e4b7576031072515c23c2b09f7f2c8bba7ee43a1e2041a4371bd954d1b";
    };
    dependencies = ["vim-addon-actions" "vim-addon-mw-utils"];
  };
  "vim-addon-php-manual" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-php-manual";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-php-manual";
      rev = "e09ccdce3d2132771d0bd32884553207cc7122d0";
      sha256 = "b2f44be3a1ceca9de7789ea9b5fd36035b720ea529f4301f3771b010d1e453c2";
    };
    dependencies = [];
  };
  "vim-addon-rdebug" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-rdebug";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-rdebug";
      rev = "c6491d10525bf926e2bf0ace06a834083038b5f9";
      sha256 = "b086d399de402be26852b3d9d28e6615d591187ff1a8444175895a2d7aff9eeb";
    };
    dependencies = ["vim-addon-mw-utils" "vim-addon-signs" "vim-addon-async"];
  };
  "vim-addon-rfc" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-rfc";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-rfc";
      rev = "39d69cbfdad649ab5572d0f52691e0556dc88ae9";
      sha256 = "daf956f8d3d58a76d23036bb57e2ed8e28e30016d901f6dfc0dce7d58f527c18";
    };
    dependencies = ["vim-addon-mw-utils"];
  };
  "vim-addon-ruby-debug-ide" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-ruby-debug-ide";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-ruby-debug-ide";
      rev = "3e178814c01c6182d5f83c01a29e459568cc8a90";
      sha256 = "a3cc1c33db487b93ce282c618978763348e25c9288751621dc24d61ccdef532c";
    };
    dependencies = ["vim-addon-mw-utils" "vim-addon-json-encoding" "vim-addon-async"];
  };
  "vim-addon-signs" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-signs";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-signs";
      rev = "17a49f293d18174ff09d1bfff5ba86e8eee8e8ae";
      sha256 = "a9c03a32e758d51106741605188cb7f00db314c73a26cae75c0c9843509a8fb8";
    };
    dependencies = [];
  };
  "vim-addon-sql" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-sql";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-sql";
      rev = "05b8a0c211f1ae4c515c64e91dec555cdf20d90b";
      sha256 = "a1334ae694e0a03229bacc8ba7e08e7223df240244c7378e3f1bd91d74e957c2";
    };
    dependencies = ["vim-addon-completion" "vim-addon-background-cmd" "tlib"];
  };
  "vim-addon-surround" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-surround";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-surround";
      rev = "133cc2f9c93d30675af73a3c63cb5130ec38b709";
      sha256 = "cf3baf897bc7c05a0f7e04970427dac813f181db7f42f078dc08ea611c42223a";
    };
    dependencies = [];
  };
  "vim-addon-syntax-checker" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-syntax-checker";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-syntax-checker";
      rev = "8eb7217e636ca717d4de5cd03cc0180c5b66ae77";
      sha256 = "aef048e664653b5007df71ac24ed34ec55d8938c763d3f80885a122e445a9b3d";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];
  };
  "vim-addon-toc" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-toc";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-toc";
      rev = "bb797cc5df1fc87c1e749965ddc8522e9cff6f00";
      sha256 = "ad7e14cfb2e9f90b34476e66c40ff94194d6148778fbe4e6ebe3002ad5425a98";
    };
    dependencies = ["vim-addon-mw-utils"];
  };
  "vim-addon-toggle-buffer" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-toggle-buffer";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-toggle-buffer";
      rev = "a1b38b9c5709cba666ed2d84ef06548f675c6b0b";
      sha256 = "672166ecfe0599177afb56b444366f587f77e9659c256ac4e41ee45cb2df6055";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];
  };
  "vim-addon-views" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-views";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-views";
      rev = "d1383ad56d0a07d7350880adbadf9de501729fa8";
      sha256 = "3c9ad434b9ecfcaa14f0b20fa980db816007a289ea6f1a78dfa2708c7075d1e7";
    };
    dependencies = ["vim-addon-mw-utils"];
  };
  "vim-addon-xdebug" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-xdebug";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-xdebug";
      rev = "45f26407305b4ce6f8f5f37d2b5e6e4354104172";
      sha256 = "0a7bf2caf36772c94bd25bfbf46bf628623809c9cfab447ff788eb74149464ef";
    };
    dependencies = ["WebAPI" "vim-addon-mw-utils" "vim-addon-signs" "vim-addon-async"];
  };
  "vim-airline" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-airline";
    src = fetchgit {
      url = "git://github.com/bling/vim-airline";
      rev = "4a2208821e1d334c4d3cdf66cd1fd0968755e16a";
      sha256 = "ea2d8bb459ae2cc378a46409c7e86db9b1cc8349bd3d2451c9a5db8ae9c8ea1d";
    };
    dependencies = [];
  };
  "vim-coffee-script" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-coffee-script";
    src = fetchgit {
      url = "git://github.com/kchmck/vim-coffee-script";
      rev = "827e4a38b07479433b619091469a7495a392df8a";
      sha256 = "89ee4c7cce9f3310be502df6b2dd2e70a715c0b06882afc9c8169fbf58b207d0";
    };
    dependencies = [];
  };
  "vim-dev-plugin" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-dev-plugin";
    src = fetchgit {
      url = "git://github.com/c9s/vim-dev-plugin";
      rev = "1dced68adc2d0873ea5cdf1780f7351c31a964d3";
      sha256 = "02111f7ac5028d88829a46031cc67fa536b35c7cc69b20b4699576b3af92c546";
    };
    dependencies = ["vim-addon-completion" "vim-addon-goto-thing-at-cursor" "vim-addon-mw-utils" "tlib"];
  };
  "vim-easy-align" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-easy-align";
    src = fetchgit {
      url = "git://github.com/junegunn/vim-easy-align";
      rev = "246139c57c4a82a9787974165dfeb7bee7dacc9c";
      sha256 = "9205b94f985f633b5cbdde63a4c5a36ce5c4f92f8a89c124ff4ba66458f98cbf";
    };
    dependencies = [];
  };
  "vim-gitgutter" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-gitgutter";
    src = fetchgit {
      url = "git://github.com/airblade/vim-gitgutter";
      rev = "57342e33a5b38cf3c15f4286f3c6cf166caef09a";
      sha256 = "0a870e1886b95778fb09088629b7dd3161aac3dd51262127334593c763fa735c";
    };
    dependencies = [];
  };
  "vim-iced-coffee-script" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-iced-coffee-script";
    src = fetchgit {
      url = "git://github.com/noc7c9/vim-iced-coffee-script";
      rev = "e42e0775fa4b1f8840c55cd36ac3d1cedbc1dea2";
      sha256 = "c7859591975a51a1736f99a433d7ca3e7638b417340a0472a63995e16d8ece93";
    };
    dependencies = ["vim-coffee-script"];
  };
  "vim-latex-live-preview" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-latex-live-preview";
    src = fetchgit {
      url = "git://github.com/xuhdev/vim-latex-live-preview";
      rev = "18625ceca4de5984f3df50cdd0202fc13eb9e37c";
      sha256 = "261852d3830189a50176f997a4c6b4ec7e25893c5b7842a3eb57eb7771158722";
    };
    dependencies = [];
  };
  "vim-ruby" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-ruby";
    src = fetchgit {
      url = "git://github.com/vim-ruby/vim-ruby";
      rev = "243d021449115235505350764bff00859ce4224f";
      sha256 = "cfd1223efb40520902c74999045287a3f7c7aa55711c72ddb6a65fe0b9ceb137";
    };
    dependencies = [];
  };
  "vim-signature" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-signature";
    src = fetchgit {
      url = "git://github.com/kshenoy/vim-signature";
      rev = "598a9275668d772ca18cc052246b96edcbe61de0";
      sha256 = "1c410aaec24840b0e0566cd6e6df100ca3c7fb83d92337efdfc359494b6c49f8";
    };
    dependencies = [];
  };
  "vim-snippets" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-snippets";
    src = fetchgit {
      url = "git://github.com/honza/vim-snippets";
      rev = "436038094a27ed635aaa11ebf50ccddc2d4b9328";
      sha256 = "1db34df31ff1526394de42997e21b47cea152dc2c014dbbb1f3bbeb8986820e1";
    };
    dependencies = [];
  };
  "vim2hs" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim2hs";
    src = fetchgit {
      url = "git://github.com/dag/vim2hs";
      rev = "f2afd55704bfe0a2d66e6b270d247e9b8a7b1664";
      sha256 = "485fc58595bb4e50f2239bec5a4cbb0d8f5662aa3f744e42c110cd1d66b7e5b0";
    };
    dependencies = [];
  };
  "vundle" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vundle";
    src = fetchgit {
      url = "git://github.com/gmarik/vundle";
      rev = "0b28e334e65b6628b0a61c412fcb45204a2f2bab";
      sha256 = "9681d471d1391626cb9ad22b2b469003d9980cd23c5c3a8d34666376447e6204";
    };
    dependencies = [];
  };
  "wombat256" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "wombat256";
    src = fetchurl {
      url = "http://www.vim.org/scripts/download_script.php?src_id=13400";
      name = "wombat256mod.vim";
      sha256 = "1san0jg9sfm6chhnr1wc5nhczlp11ibca0v7i4gf68h9ick9mysn";
    };
    buildInputs = [ unzip ];
    dependencies = [];
    meta = {
       url = "http://www.vim.org/scripts/script.php?script_id=2465";
    };
  };


}
