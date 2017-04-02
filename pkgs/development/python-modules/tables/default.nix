{ stdenv, fetchurl, python, buildPythonPackage
, cython, bzip2, lzo, numpy, numexpr, hdf5, six }:

buildPythonPackage rec {
  version = "3.3.0";
  name = "tables-${version}";

  src = fetchurl {
    url = "mirror://pypi/t/tables/${name}.tar.gz";
    sha256 = "0b4211s0zzdmh74k49ss0m9lc2ql2iazq2aa95ams6h45vqcr0w3";
  };

  buildInputs = [ hdf5 cython bzip2 lzo ];
  propagatedBuildInputs = [ numpy numexpr six ];

  # The setup script complains about missing run-paths, but they are
  # actually set.
  setupPyBuildFlags =
    [ "--hdf5=${hdf5}"
      "--lzo=${lzo}"
      "--bzip2=${bzip2.dev}"
    ];

  # Run the test suite.
  # It requires the build path to be in the python search path.
  # These tests take quite some time.
  # If the hdf5 library is built with zlib then there is only one
  # test-failure. That is the same failure as described in the following
  # github issue:
  #     https://github.com/PyTables/PyTables/issues/269
  checkPhase = ''
    ${python}/bin/${python.executable} <<EOF
    import sysconfig
    import sys
    import os
    f = "lib.{platform}-{version[0]}.{version[1]}"
    lib = f.format(platform=sysconfig.get_platform(),
                   version=sys.version_info)
    build = os.path.join(os.getcwd(), 'build', lib)
    sys.path.insert(0, build)
    import tables
    r = tables.test()
    if not r.wasSuccessful():
        sys.exit(1)
    EOF
  '';

  # Disable tests until the failure described above is fixed.
  doCheck = false;

  meta = {
    description = "Hierarchical datasets for Python";
    homepage = "http://www.pytables.org/";
    license = stdenv.lib.licenses.bsd2;
  };
}
