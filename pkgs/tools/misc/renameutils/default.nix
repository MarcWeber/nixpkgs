{stdenv, fetchurl, readline}:

stdenv.mkDerivation {
  name = "renameutils-0.12";

  src = fetchurl {
    url = mirror://savannah/renameutils/renameutils-0.12.0.tar.gz;
    sha256 = "18xlkr56jdyajjihcmfqlyyanzyiqqlzbhrm6695mkvw081g1lnb";
  };

  patches = [ ./install-exec.patch ];

  nativeBuildInputs = [ readline ];

  meta = {
    homepage = http://www.nongnu.org/renameutils/;
    description = "A set of programs to make renaming of files faster";
  };
}
