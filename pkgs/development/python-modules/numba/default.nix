{ stdenv
, fetchurl
, python
, buildPythonPackage
, isPy27
, isPy33
, isPy3k
, numpy
, llvmlite
, argparse
, funcsigs
, singledispatch
, libcxx
}:

buildPythonPackage rec {
  version = "0.34.0";
  pname = "numba";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/n/numba/${name}.tar.gz";
    sha256 = "4f86df9212cb2678598e6583973ef1df978f3e3ba497b4dc6f91848887710577";
  };

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [numpy llvmlite argparse] ++ stdenv.lib.optional (!isPy3k) funcsigs ++ stdenv.lib.optional (isPy27 || isPy33) singledispatch;

  # Copy test script into $out and run the test suite.
  checkPhase = ''
    python -m numba.runtests
  '';
  # ImportError: cannot import name '_typeconv'
  doCheck = false;

  meta =  {
    homepage = http://numba.pydata.org/;
    license = stdenv.lib.licenses.bsd2;
    description = "Compiling Python code using LLVM";
    maintainers = with stdenv.lib.maintainers; [ fridh ];
  };
}
