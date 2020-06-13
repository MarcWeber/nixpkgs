{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.7.0";
  extraMeta.branch = "5.7";

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  src = fetchurl {
    # url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.7.tar.xz";
    sha256 = "1q6pq4ggyyf9syfgg3x72gq0n1k0qi75g0rrg97xh8pqcaxn70fy";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
