{ cabal, aeson, attoparsecConduit, authenticate, base16Bytestring
, base64Bytestring, binary, blazeBuilder, blazeHtml, blazeMarkup
, byteable, conduit, conduitExtra, cryptohash, dataDefault
, emailValidate, fileEmbed, hamlet, httpClient, httpConduit
, httpTypes, liftedBase, mimeMail, network, persistent
, persistentTemplate, random, resourcet, safe, shakespeare
, shakespeareCss, shakespeareJs, text, time, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.3.1.1";
  sha256 = "0mw04v8gnhv9gnv7kv2v1x5df63zjdmi52r5bv1fzqay1s5b83ir";
  buildDepends = [
    aeson attoparsecConduit authenticate base16Bytestring
    base64Bytestring binary blazeBuilder blazeHtml blazeMarkup byteable
    conduit conduitExtra cryptohash dataDefault emailValidate fileEmbed
    hamlet httpClient httpConduit httpTypes liftedBase mimeMail network
    persistent persistentTemplate random resourcet safe shakespeare
    shakespeareCss shakespeareJs text time transformers
    unorderedContainers wai yesodCore yesodForm yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
