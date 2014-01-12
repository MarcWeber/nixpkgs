{ stdenv, fetchurl, erlang, rebar, makeWrapper, coreutils }:

let
  version = "0.12.0";
in
stdenv.mkDerivation {
  name = "elixir-${version}";

  src = fetchurl {
    url = "https://github.com/elixir-lang/elixir/archive/v${version}.tar.gz";
    sha256 = "0cir2y36zljwphiqyz8xmq7qq0f094jmfy3qwk3wdm05c05nqnc8";
  };

  buildInputs = [ erlang rebar makeWrapper ];

  preBuild = ''
    substituteInPlace rebar \
      --replace "/usr/bin/env escript" ${erlang}/bin/escript
    substituteInPlace Makefile \
      --replace '$(shell echo `pwd`/rebar)' ${rebar}/bin/rebar \
      --replace "/usr/local" $out
  '';

  postFixup = ''
    # Elixirs binaries are shell scripts which run erl. This adds some
    # stuff to PATH so the scripts run without problems.

    for f in $out/bin/*
    do
      wrapProgram $f \
      --prefix PATH ":" "${erlang}/bin:${coreutils}/bin"
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://elixir-lang.org/";
    description = "A functional, meta-programming aware language built on top of the Erlang VM";

    longDescription = ''
      Elixir is a functional, meta-programming aware language built on
      top of the Erlang VM. It is a dynamic language with flexible
      syntax and macro support that leverages Erlang's abilities to
      build concurrent, distributed and fault-tolerant applications
      with hot code upgrades.
    '';

    license = licenses.epl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
