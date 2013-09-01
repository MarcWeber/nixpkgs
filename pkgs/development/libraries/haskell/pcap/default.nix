{ cabal, libpcap, network, time }:

cabal.mkDerivation (self: {
  pname = "pcap";
  version = "0.4.5.2";
  sha256 = "0pydw62qqw61sxfd8x9vvwgpgl3zp6mqv8rm4c825ymzyipjxsg7";
  buildDepends = [ network time ];
  extraLibraries = [ libpcap ];
  meta = {
    homepage = "https://github.com/bos/pcap";
    description = "A system-independent interface for user-level packet capture";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
