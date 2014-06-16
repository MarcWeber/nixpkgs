{ cabal, comonad, fingertree, hashable, keys, pointed
, semigroupoids, semigroups, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "reducers";
  version = "3.10.2.1";
  sha256 = "1wn6q6cw9is1gan9y5n3fzjkhmpjpria4p13zp4kqxmj881067vy";
  buildDepends = [
    comonad fingertree hashable keys pointed semigroupoids semigroups
    text transformers unorderedContainers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/ekmett/reducers/";
    description = "Semigroups, specialized containers and a general map/reduce framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
