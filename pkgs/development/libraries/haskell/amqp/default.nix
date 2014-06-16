{ cabal, binary, clock, connection, dataBinaryIeee754, hspec
, hspecExpectations, monadControl, network, split, text, vector
, xml
}:

cabal.mkDerivation (self: {
  pname = "amqp";
  version = "0.8.3";
  sha256 = "0gl5vdhbic8llhbqmhnwj0wvykhbrci6zz53v5cayqfcwi1v1dw2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary clock connection dataBinaryIeee754 monadControl network
    split text vector xml
  ];
  testDepends = [
    binary clock connection dataBinaryIeee754 hspec hspecExpectations
    network split text vector
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/hreinhardt/amqp";
    description = "Client library for AMQP servers (currently only RabbitMQ)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
