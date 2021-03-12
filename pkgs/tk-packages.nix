{ pkgs
, stdenv
}:

let

inherit (pkgs) tcl tk;

in

with pkgs.lib;

{

  tkimg = stdenv.mkDerivation rec {
    name = "tk-img-${version}";
    version = "1.4.13";


    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        pkgs.fetchurl {
          url = "mirror://sourceforge.net/tkimg/tkimg/1.4/tkimg%201.4.13/Img-1.4.13-Linux64.tar.gz";
          sha256 = "0jwnbpz7l752l0r2hhpfqvp5bxm9j4dlqlxfq8xvcdqwcfy74yfz";
        }
      else if stdenv.hostPlatform.system == "i686-linux" then
        pkgs.fetchurl {
          url = "mirror:///tkimg/tkimg/1.4/tkimg%201.4.13/Img-1.4.13-Linux32.tar.gz";
          sha256 = "1hxykqj4ivc32nij6wn0ikqvz037n3sfr4fdwiz9n5fr0zmm3pd1";

        }
    else
      throw "tk-img isn't supported (yet?) on ${stdenv.hostPlatform.system}";


    buildInputs = [ tcl tk ];
    installPhase = ''
    mkdir -p $out/lib/tkimg
    find
    mv * $out/lib/tkimg
    '';

  };


  tkimgsrc = stdenv.mkDerivation rec {
    name = "tk-img-${version}";
    version = "1.4.13";

    src = pkgs.fetchurl {
      url = "mirror://sourceforge/tkimg/tkimg/1.4/tkimg%201.4.13/Img-1.4.13-Source.tar.gz";
      sha256 = "0qyi80f9zwlx8sx9km0d1wfa2d3x846g10ag4gqxqllpmlf8r1ph";
    };

    buildInputs = [
      pkgs.tk pkgs.tcl
    ];

    # ''--prefix=/''
    configureFlags = [
      ''--with-tcl=${pkgs.tcl}/lib''
      ''--with-tcl=${pkgs.tcl}/lib''
      ''--with-tk=${pkgs.tk}/lib''
      ''--with-tkinclude=${pkgs.tk.dev}/include''
    ];

    buildPhase = ''
    makeFlags=INSTALL_ROOT=$out
    runHook buildPhase
    '';

    buildFlags = "install-libraries";

    installPhase = ''
      mkdir -p $out
      link(){ # TODO move somewhere ? see tkimgsrc
        local from="$1"
        local to="$2"
        local b
        echo "calling link $from $to"

        for x in "$from"/*; do
          b="$(basename "$x")"
          if [ -d "$to/$b" ]; then
            link "$x" "$to/$b"
          else
            ln -s "$x" "$to/$b"
          fi
        done
      }

      for dir in $out/nix/store/*; do
        link "$dir" "$out"
      done
    '';

    # build install without documentation which would require dtplite
    # buildPhase = ''
    #   make install-libraries
    # '';

  };
}
