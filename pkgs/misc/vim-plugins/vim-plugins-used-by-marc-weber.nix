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

  "WebAPI" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "WebAPI";
    src = fetchgit {
      url = "git://github.com/mattn/webapi-vim";
      rev = "a7789abffe936db56e3152e23733847f94755753";
      sha256 = "455b84d9fd13200ff5ced5d796075f434a7fb9c00f506769174579266ae2be80";
    };
    dependencies = [];

  };
  "github:MarcWeber" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "github-MarcWeber";
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

  unpackPhase = ''
    sourceRoot=d
    (
     mkdir $sourceRoot; cd $sourceRoot;
     unzip $src
    )
  '';
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
  "phpcomplete" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "phpcomplete";
    src = fetchgit {
      url = "git://github.com/shawncplus/phpcomplete.vim";
      rev = "1fffeb24407e93298680dbb1c077736db1fa0f4b";
      sha256 = "6b8fbe0d40ca0cb1d59fcce061ddd139f510d081c85e40e132b442f214b1d773";
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
    dependencies = ["vim-misc"];

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
  "vim-dev-plugin" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-dev-plugin";
    src = fetchgit {
      url = "git://github.com/c9s/vim-dev-plugin";
      rev = "1dced68adc2d0873ea5cdf1780f7351c31a964d3";
      sha256 = "02111f7ac5028d88829a46031cc67fa536b35c7cc69b20b4699576b3af92c546";
    };
    dependencies = ["vim-addon-completion" "vim-addon-goto-thing-at-cursor" "vim-addon-mw-utils" "tlib"];

  };
  "vim-iced-coffee-script" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-iced-coffee-script";
    src = fetchgit {
      url = "git://github.com/noc7c9/vim-iced-coffee-script";
      rev = "e42e0775fa4b1f8840c55cd36ac3d1cedbc1dea2";
      sha256 = "c7859591975a51a1736f99a433d7ca3e7638b417340a0472a63995e16d8ece93";
    };
    dependencies = [];

  };
  "vim-misc" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-misc";
    src = fetchgit {
      url = "git://github.com/xolox/vim-misc";
      rev = "038faedc0767141dd4469978bc6575807fa3eb31";
      sha256 = "707e42b5db058e04e0a4abdec2e42efd8afc0e4e3f04174f99097fa6359ccf70";
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
  "vim-snippets" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-snippets";
    src = fetchgit {
      url = "git://github.com/honza/vim-snippets";
      rev = "436038094a27ed635aaa11ebf50ccddc2d4b9328";
      sha256 = "1db34df31ff1526394de42997e21b47cea152dc2c014dbbb1f3bbeb8986820e1";
    };
    dependencies = [];

  };


}
