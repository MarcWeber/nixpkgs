{ stdenv, fetchurl, patchelf }:

let
  arch = if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "i386"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  sha256 = if stdenv.system == "x86_64-linux" then "c4b100bbf8cda0334e20793e02bf400d15266cb9d089917bd2b6b9d49dd37d19"
    else if stdenv.system == "i686-linux" then "5760471fcea396efd158758aa350b1c48a9d0633765a5e3b059baf8aeab615fa"
    else throw "Bittorrent Sync for: ${stdenv.system} not supported!";

  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.libc ];
in
stdenv.mkDerivation rec {
  name = "btsync-${version}";
  version = "1.4.93";

  src  = fetchurl {
    url  = "http://syncapp.bittorrent.com/${version}/btsync_${arch}-${version}.tar.gz";
    inherit sha256;
  };

  dontStrip   = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot  = ".";
  buildInputs = [ patchelf ];

  installPhase = ''
    mkdir -p "$out/bin/"
    cp -r "btsync" "$out/bin/"

    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} "$out/bin/btsync"
  '';

  meta = {
    description = "Automatically sync files via secure, distributed technology";
    homepage    = "http://www.bittorrent.com/sync";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iElectric thoughtpolice ];
  };
}
