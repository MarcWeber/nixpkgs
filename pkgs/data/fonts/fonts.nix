{ fetchurl, stdenv, unzip }:

let 

  copyRestSh = name: ''
  # rest could contain license or such, make sure its in the store
  mkdir -p $out/share/${name}
  mv * $out/share/${name}
  '';

  mkFontDerivation = {name, src, description ? "a font", copyRest ? copyRestSh name, unpackPhase ? null}:

    stdenv.mkDerivation {
      inherit name src unpackPhase;
      buildInputs = [ unzip ];
      # buildInputs = [ mkfontdir mkfontscale ];

      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        mv *.ttf $out/share/fonts/truetype

        ${copyRest}
      '';

      meta = {
        inherit description;
      };
    };

in {

  # font squirrel fonts:
  droidSerif = mkFontDerivation {
    name = "droid-serif";
    unpackPhase = ''unzip $src; sourceRoot=$TMP'';
    src = fetchurl {
      # sorry, the hash is different for each download
      url = http://mawercer.de/tmp/droid-serif.zip;
      sha256 = "1jbscsrmkzj4fajkfcvhm3vjrnxma2slw3i4hzrp0p9clmzw3q4j";
    };
  };
}
