{ stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "ec2-api-tools-1.6.0.0";
  
  src = fetchurl {
<<<<<<< HEAD
<<<<<<< HEAD
    url = http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip;
    sha256 = "fef3661647af646e2fff37a29a4868ecfc8a52f333812757bd1c4d091eb9ad8d";
=======
=======
>>>>>>> experimental/updates
<<<<<<< HEAD:pkgs/tools/virtualization/amazon-ec2-api-tools/default.nix
    url = http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip;
    sha256 = "fef3661647af646e2fff37a29a4868ecfc8a52f333812757bd1c4d091eb9ad8d";
=======
    url = "http://nixos.org/tarballs/${name}.zip";
    sha256 = "1j9isvi6g68zhk7zxs29yad2d0rpnbqx8fz25yn5paqx9c8pzqcl";
>>>>>>> refs/top-bases/experimental/updates:pkgs/tools/virtualization/ec2-api-tools/default.nix
<<<<<<< HEAD
>>>>>>> experimental/updates
=======
=======
    url = http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip;
    sha256 = "fef3661647af646e2fff37a29a4868ecfc8a52f333812757bd1c4d091eb9ad8d";
>>>>>>> 9cd16bca0f94dbbdf94ec0fa636393a9d9228d68
>>>>>>> experimental/updates
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase =
    ''
      mkdir -p $out
      mv * $out
      rm $out/bin/*.cmd # Windows stuff

      for i in $out/bin/*; do
          wrapProgram $i \
            --set EC2_HOME $out \
            --set JAVA_HOME ${jre}
      done
    ''; # */
  
  meta = {
    homepage = http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351;
    description = "Command-line tools to create and manage Amazon EC2 virtual machines";
    license = "unfree-redistributable";
  };
}
