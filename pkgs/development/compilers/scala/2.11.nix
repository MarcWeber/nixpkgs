{ stdenv, fetchurl, makeWrapper, jre, gnugrep, coreutils }:

stdenv.mkDerivation rec {
  name = "scala-2.11.10";

  src = fetchurl {
    url = "http://www.scala-lang.org/files/archive/${name}.tgz";
    sha256 = "10rs8ak3qyxggw24ga3gjcpl3x8r1b3ykrdfrym1n154b1rrs904";
  };

  propagatedBuildInputs = [ jre ] ;
  buildInputs = [ makeWrapper ] ;

  installPhase = ''
    mkdir -p $out
    rm "bin/"*.bat
    mv * $out

    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p \
        --prefix PATH ":" ${coreutils}/bin \
        --prefix PATH ":" ${gnugrep}/bin \
        --prefix PATH ":" ${jre}/bin \
        --set JAVA_HOME ${jre}
    done
  '';

  meta = {
    description = "General purpose programming language";
    longDescription = ''
      Scala is a general purpose programming language designed to express
      common programming patterns in a concise, elegant, and type-safe way.
      It smoothly integrates features of object-oriented and functional
      languages, enabling Java and other programmers to be more productive.
      Code sizes are typically reduced by a factor of two to three when
      compared to an equivalent Java application.
    '';
    homepage = http://www.scala-lang.org/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
    branch = "2.11";
  };
}
