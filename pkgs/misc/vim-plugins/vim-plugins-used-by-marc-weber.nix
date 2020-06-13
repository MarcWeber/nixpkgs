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
      sha256 = "0548zcl1qs78fjqbilc8jgbj0zy7dzd2jl5s5ghyrl2m9yjfgx8w";
    };

    dependencies = [];

  };
  "github:MarcWeber" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "github-MarcWeber";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-MarcWeber";
      rev = "7de7c66bab0578714db5a4f5ef8e4d7fdff33b20";
      sha256 = "1z8lhzygjhssjaadhmlclhrzhvj8gh8bwfddswdw853lrvdrr5w0";
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
      sha256 = "0vb832l9yxj919f5hfg6qj6bn9ni57gnjd3bj7zpq7d4iv2s4wdh";
    };
    dependencies = ["vim-misc"];

  };
  "rust" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "rust";
    src = fetchgit {
      url = "git://github.com/wting/rust.vim";
      rev = "0fd423990cfa69336fb6c1d5d58aa2091e7b4e76";
      sha256 = "09ywa4gah516j9jcpxxjwh8bbsqbng0y3z8n8qwvs4h8zw0w2f5h";
    };
    dependencies = [];

  };
  "snipmate" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "snipmate";
    src = fetchgit {
      url = "git://github.com/garbas/vim-snipmate";
      rev = "8cb6c3ebe267873dc5abb9a36305c75d9564dea4";
      sha256 = "00agsxdh6jxim6g8llikjhb2gdzm5qvm6cgawvxcspmvyyycpc0k";
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
      sha256 = "17jgpvl879ik53rr3razfnbpfx63mzpp1rlvxxjsvvrk4g45dssm";
    };
    dependencies = [];

  };
  "textobj-rubyblock" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "textobj-rubyblock";
    src = fetchgit {
      url = "git://github.com/nelstrom/vim-textobj-rubyblock";
      rev = "b5b84e49e609439e81aa03fa8e605a6097185665";
      sha256 = "1wh5xsi5gdhj8ilbj8m7fxdvn44pk8zcv7ljkj2x2jywihwql738";
    };
    dependencies = ["textobj-user"];

  };
  "textobj-user" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "textobj-user";
    src = fetchgit {
      url = "git://github.com/kana/vim-textobj-user";
      rev = "9aa5fd050ecce650fb7ff018397e73a66a41c76b";
      sha256 = "1v468zp9dbsdbh6a3gc6xc2qyd8hhqgp2hr5xnaxg099gf3p0z6y";
    };
    dependencies = [];

  };
  "tlib" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "tlib";
    src = fetchgit {
      url = "git://github.com/tomtom/tlib_vim";
      rev = "b730863d67f26e01868fee5a9a680a0c721bd44a";
      sha256 = "0q4bppx1jl26k6rpkafkbd8nsxkz6fdw5xib65d3b6ia5y598y21";
    };
    dependencies = [];

  };
  "vim-addon-actions" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-actions";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-actions";
      rev = "a5d20500fb8812958540cf17862bd73e7af64936";
      sha256 = "1wfkwr89sn2w97i94d0dqylcg9mr6pirjadi0a4l492nfnsh99bc";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];

  };
  "vim-addon-async" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-async";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-async";
      rev = "dadc96e188f1cdacbac62129eb29a1eacfed792c";
      sha256 = "0b95l4ig8as82swhavsdica93bv5j55kvldfl7frkfp5zwcwi90f";
    };
    dependencies = ["vim-addon-signs"];

  };
  "vim-addon-background-cmd" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-background-cmd";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-background-cmd";
      rev = "14df72660a95804a57c02b9ff0ae3198608e2491";
      sha256 = "09lh6hqbx05gm7njhpqvhqdwig3pianq9rddxmjsr6b1vylgdgg4";
    };
    dependencies = ["vim-addon-mw-utils"];

  };
  "vim-addon-commenting" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-commenting";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-commenting";
      rev = "b7cf748ac1c9bf555cbd347589e3b7196030d20b";
      sha256 = "0alak8h33vada2ckb0v06y82qlib5mhyc2yswlv1rqh8ypzhq3mc";
    };
    dependencies = [];

  };
  "vim-addon-completion" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-completion";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-completion";
      rev = "80f717d68df5b0d7b32228229ddfd29c3e86e435";
      sha256 = "08acffzy847w8b5j8pdw6qsidm2859ki5q351n4r7fkr969p80mi";
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
      sha256 = "11vj5p7dxr8rmyv6c2agv6bkid8v3b23f7rxj2gg3ipvi190ly22";
    };
    dependencies = ["vim-addon-goto-thing-at-cursor" "vim-addon-views" "vim-addon-mw-utils" "tlib"];

  };
  "vim-addon-goto-thing-at-cursor" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-goto-thing-at-cursor";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-goto-thing-at-cursor";
      rev = "f052e094bdb351829bf72ae3435af9042e09a6e4";
      sha256 = "1ksm2b0j80zn8sz2y227bpcx4jsv76lwgr2gpgy2drlyqhn2vlv0";
    };
    dependencies = ["tlib"];

  };
  "vim-addon-haskell" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-haskell";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-haskell";
      rev = "3d9f6399debe33cb3f46a0d3e3dd1ae0162ed36b";
      sha256 = "1hfar6yxkrnbvlcvdwyqzj94p5svjwrb8rcsikng0fwzfx9v20yz";
    };
    dependencies = ["vim-addon-background-cmd" "vim-addon-views" "vim-addon-actions" "vim-addon-mw-utils" "tlib"];

  };
  "vim-addon-json-encoding" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-json-encoding";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-json-encoding";
      rev = "0aba90c873742b52d020f3c889a37382552fad08";
      sha256 = "01kllbbcm8jpnqrc19mj61ja4zvd2gmx6k17sxfdg07ysls11k0y";
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
      sha256 = "18cn1pjr9x0fvg04jsrxy4rg4wsrhxf09imbarc73cmmmj93rc4b";
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
      sha256 = "147s1k4n45d3x281vj35l26sv4waxjlpqdn83z3k9n51556h1d45";
    };
    dependencies = [];

  };
  "vim-addon-nix" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-nix";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-nix";
      rev = "7b0a376bb1797fef8da2dc14e768f318bcb671e8";
      sha256 = "00dsba2a0az9bw1sni12km1vdga9x32dapxaj5gmq98hzqlhklyp";
    };
    dependencies = ["vim-addon-completion" "vim-addon-goto-thing-at-cursor" "vim-addon-errorformats" "vim-addon-actions" "vim-addon-mw-utils" "tlib"];

  };
  "vim-addon-other" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-other";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-other";
      rev = "f78720c9cb5bf871cabb13c7cbf94378dbf0163b";
      sha256 = "0cjz7mlyfkkncas4ss7rwxb0q38ls1qw1p15hac1imscscsvyjc6";
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
      sha256 = "0i4gfp30hmw1vqjl6zxjrgkca3ikdkcnjmma2mncjmcr6f59kjzy";
    };
    dependencies = [];

  };
  "vim-addon-sql" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-sql";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-sql";
      rev = "05b8a0c211f1ae4c515c64e91dec555cdf20d90b";
      sha256 = "15l2201jkfml08znvkkpy7fm3wn87n91zgd9ysrf5h73amjx9y2w";
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
      sha256 = "1xq38kfdm36c34ln66znw841q797w5gm8bpq1x64bsf2h6n3ml03";
    };
    dependencies = ["vim-addon-mw-utils" "tlib"];

  };
  "vim-addon-views" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-views";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-views";
      rev = "d1383ad56d0a07d7350880adbadf9de501729fa8";
      sha256 = "09gqh7w5rk4lmra706schqaj8dnisf396lpsipm7xv6gy1qbslnv";
    };
    dependencies = ["vim-addon-mw-utils"];

  };
  "vim-addon-xdebug" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-addon-xdebug";
    src = fetchgit {
      url = "git://github.com/MarcWeber/vim-addon-xdebug";
      rev = "45f26407305b4ce6f8f5f37d2b5e6e4354104172";
      sha256 = "1i64ppdfp2qqq7vw1jf160mj4ikc04v39iazdab83xmiqjsh8ixw";
    };
    dependencies = ["WebAPI" "vim-addon-mw-utils" "vim-addon-signs" "vim-addon-async"];

  };
  "vim-dev-plugin" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-dev-plugin";
    src = fetchgit {
      url = "git://github.com/c9s/vim-dev-plugin";
      rev = "1dced68adc2d0873ea5cdf1780f7351c31a964d3";
      sha256 = "1dizpfd3zdzsapcmhq8rvnll28kn7skcc5w8viby07rzvqzfl25g";
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
      sha256 = "1hz7rnacf5bi8g5gkwqknlvh3kwdq9ssdvqgg7d95hiww7giplnk";
    };
    dependencies = [];

  };
  "vim-ruby" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-ruby";
    src = fetchgit {
      url = "git://github.com/vim-ruby/vim-ruby";
      rev = "243d021449115235505350764bff00859ce4224f";
      sha256 = "19hr5d5667h488qxl05lzx74qaxfs0zffcbmfypiil2zs3l2g9f7";
    };
    dependencies = [];

  };
  "vim-snippets" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
    name = "vim-snippets";
    src = fetchgit {
      url = "git://github.com/honza/vim-snippets";
      rev = "436038094a27ed635aaa11ebf50ccddc2d4b9328";
      sha256 = "0rrgbv0vgbvg0jwz2fjnpcqwknqj858317mygz4n8m8in3q8vrd3";
    };
    dependencies = [];

  };


}
