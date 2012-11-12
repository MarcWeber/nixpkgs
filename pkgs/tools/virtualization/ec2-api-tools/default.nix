{ stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "ec2-api-tools-1.6.5.1";

  src = fetchurl {
    url = http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip;
    sha256 = "0zdjgkgsp1i4fyadqiacqvjf6mqwgkwhn6dk5wd8llragx137v0n";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase =
    ''
      d=$out/libexec/ec2-api-tools
      mkdir -p $d
      mv * $d
      rm $d/bin/*.cmd # Windows stuff

      for i in $d/bin/*; do
          b=$(basename $i)
          if [ $b = "ec2-cmd" ]; then continue; fi
          makeWrapper $i $out/bin/$(basename $i) \
            --set EC2_HOME $d \
            --set JAVA_HOME ${jre}
      done
    ''; # */

  meta = {
    homepage = http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351;
    description = "Command-line tools to create and manage Amazon EC2 virtual machines";
    license = "unfree-redistributable";
  };
}
