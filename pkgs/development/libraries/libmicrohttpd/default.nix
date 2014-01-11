{stdenv, fetchurl, curl, libgcrypt}:

stdenv.mkDerivation rec {
  name = "libmicrohttpd-0.9.33";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/${name}.tar.gz";
    sha256 = "0nfm3h7mfb03hf4kfyap8dr35shm6sppsq6da03853sljy27wn6r";
  };

  buildInputs = [ curl libgcrypt ];

  preCheck =
    # Since `localhost' can't be resolved in a chroot, work around it.
    '' for i in "src/test"*"/"*.[ch]
       do
         sed -i "$i" -es/localhost/127.0.0.1/g
       done
    '';

  doCheck = true;

  meta = {
    description = "GNU libmicrohttpd, an embeddable HTTP server library";

    longDescription = ''
      GNU libmicrohttpd is a small C library that is supposed to make
      it easy to run an HTTP server as part of another application.
    '';

    license = "LGPLv2+";

    homepage = http://www.gnu.org/software/libmicrohttpd/;

    maintainers = [ ];
  };
}
