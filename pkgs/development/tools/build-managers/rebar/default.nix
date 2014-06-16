{ stdenv, fetchurl, erlang }:


let
  version = "2.3.0";
in
stdenv.mkDerivation {
  name = "rebar-${version}";

  src = fetchurl {
    url = "https://github.com/rebar/rebar/archive/${version}.tar.gz";
    sha256 = "0g23ib96lalpmynx39fprlw08ivgyb7i6c6a8jvgqwr9jmd0nj06";
  };

  buildInputs = [ erlang ];

  buildPhase = "escript bootstrap";
  installPhase = ''
    mkdir -p $out/bin
    cp rebar $out/bin/rebar
  '';

  meta = {
    homepage = "https://github.com/rebar/rebar";
    description = "Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases";

    longDescription = ''
      rebar is a self-contained Erlang script, so it's easy to
      distribute or even embed directly in a project. Where possible,
      rebar uses standard Erlang/OTP conventions for project
      structures, thus minimizing the amount of build configuration
      work. rebar also provides dependency management, enabling
      application writers to easily re-use common libraries from a
      variety of locations (git, hg, etc).
      '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
  };
}
