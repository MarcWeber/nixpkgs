{ stdenv, fetchurl, cups }:

let
  version = "1.6.8";
in
  stdenv.mkDerivation {

    name = "epson-escpr-${version}";
  
    src = fetchurl {
      url = "https://download3.ebz.epson.net/dsc/f/03/00/05/10/61/125006df4ffc84861395c1158a02f1f73e6f1753/epson-inkjet-printer-escpr-1.6.8-1lsb3.2.tar.gz";
      sha256 = "02v8ljzw6xhfkz1x8m50mblcckgfbpa89fc902wcmi2sy8fihgh4";
    }; 

    patches = [ ./cups-filter-ppd-dirs.patch ]; 

    buildInputs = [ cups ];

    meta = with stdenv.lib; {
      homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
      description = "ESC/P-R Driver (generic driver)";
      longDescription = ''
        Epson Inkjet Printer Driver (ESC/P-R) for Linux and the
	corresponding PPD files. The list of supported printers
	can be found at http://www.openprinting.org/driver/epson-escpr/ .

	To use the driver adjust your configuration.nix file:
	  services.printing = {
	    enable = true;
	    drivers = [ pkgs.epson-escpr ];
	  };
      '';
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ artuuge ];
      platforms = platforms.linux;
    };

  }
