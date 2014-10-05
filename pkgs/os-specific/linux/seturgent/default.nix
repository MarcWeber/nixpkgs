{ stdenv, fetchurl, libX11, xproto, xdotool, unzip }:

stdenv.mkDerivation {
  name = "seturgent";

  src = fetchurl {
    url = "https://github.com/hiltjo/seturgent/archive/ada70dcb15865391e5cdcab27a0739a304a17e03.zip";
    sha256 = "0q1sr6aljkw2jr9b4xxzbc01qvnd5vk3pxrypif9yd8xjw4wqwri";
  };

  buildInputs = [
    libX11 xproto unzip
  ];

  installPhase = ''
    mkdir -pv $out/bin
    mv seturgent $out/bin
  '';

  meta = {
      platforms = stdenv.lib.platforms.linux;
      description = "Set an application's urgency hint (or not)";
      maintainers = [ stdenv.lib.maintainers.yarr ];
      homepage = https://github.com/hiltjo/seturgent;
      license = stdenv.lib.licenses.mit;
  };
}