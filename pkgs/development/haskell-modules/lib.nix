{ pkgs }:

rec {

  overrideCabal = drv: f: (drv.override (args: args // {
    mkDerivation = drv: args.mkDerivation (drv // f drv);
  })) // {
    overrideScope = scope: overrideCabal (drv.overrideScope scope) f;
  };

  doHaddock = drv: overrideCabal drv (drv: { doHaddock = true; });
  dontHaddock = drv: overrideCabal drv (drv: { doHaddock = false; });

  doJailbreak = drv: overrideCabal drv (drv: { jailbreak = true; });
  dontJailbreak = drv: overrideCabal drv (drv: { jailbreak = false; });

  doCheck = drv: overrideCabal drv (drv: { doCheck = true; });
  dontCheck = drv: overrideCabal drv (drv: { doCheck = false; });

  dontDistribute = drv: overrideCabal drv (drv: { hydraPlatforms = []; });

  appendConfigureFlag = drv: x: overrideCabal drv (drv: { configureFlags = (drv.configureFlags or []) ++ [x]; });
  removeConfigureFlag = drv: x: overrideCabal drv (drv: { configureFlags = pkgs.stdenv.lib.remove x (drv.configureFlags or []); });

  addBuildTool = drv: x: addBuildTools drv [x];
  addBuildTools = drv: xs: overrideCabal drv (drv: { buildTools = (drv.buildTools or []) ++ xs; });

  addExtraLibrary = drv: x: addExtraLibraries drv [x];
  addExtraLibraries = drv: xs: overrideCabal drv (drv: { extraLibraries = (drv.extraLibraries or []) ++ xs; });

  addBuildDepend = drv: x: addBuildDepends drv [x];
  addBuildDepends = drv: xs: overrideCabal drv (drv: { buildDepends = (drv.buildDepends or []) ++ xs; });

  addPkgconfigDepend = drv: x: addPkgconfigDepends drv [x];
  addPkgconfigDepends = drv: xs: overrideCabal drv (drv: { buildDepends = (drv.pkgconfigDepends or []) ++ xs; });

  enableCabalFlag = drv: x: appendConfigureFlag (removeConfigureFlag drv "-f-${x}") "-f${x}";
  disableCabalFlag = drv: x: appendConfigureFlag (removeConfigureFlag drv "-f${x}") "-f-${x}";

  markBroken = drv: overrideCabal drv (drv: { broken = true; });
  markBrokenVersion = version: drv: assert drv.version == version; markBroken drv;

  enableLibraryProfiling = drv: overrideCabal drv (drv: { enableLibraryProfiling = true; });
  disableLibraryProfiling = drv: overrideCabal drv (drv: { enableLibraryProfiling = false; });

  enableSharedExecutables = drv: overrideCabal drv (drv: { enableSharedExecutables = true; });
  disableSharedExecutables = drv: overrideCabal drv (drv: { enableSharedExecutables = false; });

  enableSharedLibraries = drv: overrideCabal drv (drv: { enableSharedLibraries = true; });
  disableSharedLibraries = drv: overrideCabal drv (drv: { enableSharedLibraries = false; });

  enableSplitObjs = drv: overrideCabal drv (drv: { enableSplitObjs = true; });
  disableSplitObjs = drv: overrideCabal drv (drv: { enableSplitObjs = false; });

  enableStaticLibraries = drv: overrideCabal drv (drv: { enableStaticLibraries = true; });
  disableStaticLibraries = drv: overrideCabal drv (drv: { enableStaticLibraries = false; });

  appendPatch = drv: x: appendPatches drv [x];
  appendPatches = drv: xs: overrideCabal drv (drv: { patches = (drv.patches or []) ++ xs; });

  doHyperlinkSource = drv: overrideCabal drv (drv: { hyperlinkSource = true; });
  dontHyperlinkSource = drv: overrideCabal drv (drv: { hyperlinkSource = false; });

  sdistTarball = pkg: pkgs.lib.overrideDerivation pkg (drv: {
    name = "${drv.pname}-source-${drv.version}";
    buildPhase = "./Setup sdist";
    haddockPhase = ":";
    checkPhase = ":";
    installPhase = "install -D dist/${drv.pname}-*.tar.gz $out/${drv.pname}-${drv.version}.tar.gz";
    fixupPhase = ":";
  });

  buildFromSdist = pkg: pkgs.lib.overrideDerivation pkg (drv: {
    unpackPhase = let src = sdistTarball pkg; tarname = "${pkg.pname}-${pkg.version}"; in ''
      echo "Source tarball is at ${src}/${tarname}.tar.gz"
      tar xf ${src}/${tarname}.tar.gz
      cd ${pkg.pname}-*
    '';
  });

  buildStrictly = pkg: buildFromSdist (appendConfigureFlag pkg "--ghc-option=-Wall --ghc-option=-Werror");

  triggerRebuild = drv: i: overrideCabal drv (drv: { postUnpack = ": trigger rebuild ${toString i}"; });

  #FIXME: throw this away sometime in the future. added 2015-08-18
  withHoogle = throw "withHoogle is no longer supported, use ghcWithHoogle instead";
}
