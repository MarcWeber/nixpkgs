{stdenv, fetchurl, boost, zlib, fetchsvn}:

stdenv.mkDerivation {
  name = "anyterm";

  enableParallelBuilding = true;

  # src = fetchsvn {
  #   url = "http://svn.anyterm.org/anyterm/tags/releases/1.1/1.1.9/";
  #   rev = "18182";
  #   sha256 = "143i2yi6b1rkms0qb6hdxqi30z5xxdcp2ggggy6vpgynd6hygav2";
  # };

  src = fetchsvn {
    url = "http://svn.anyterm.org/anyterm/tags/releases/1.2/1.2.3/";
    rev = "18182";
    sha256 = "145if8gqzayz6k1g133ykvp52yyjrwgfv1xi5mywg04hb13cr2rx";
  };

  # src = fetchurl {
  #   url = http://anyterm.org/download/anyterm-1.1.29.tbz2;
  #   sha256 = "0ilqxj50mmm6c216dlg4gwy25kmnwiyz3gcmsb74xjs04b7i0xvf";
  # };

  buildInputs = [
    boost # only header files are used 
    zlib
  ];

  # patches = ./patch.patch;

  installPhase = ''
    mkdir -p $out/bin
    mv build/anytermd $out/bin
  '';

  meta = {
    description = "Access SSH Shell using the browser";
    homepage = http://anyterm.org/index.html;
    license = "GPL";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
