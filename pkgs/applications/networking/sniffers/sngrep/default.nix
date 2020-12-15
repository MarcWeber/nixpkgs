{ stdenv, autoconf, automake, fetchFromGitHub, libpcap, ncurses, openssl, pcre }:

stdenv.mkDerivation rec {
  pname = "sngrep";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "irontec";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lnwsw9x4y4lr1yh749y24f71p5zsghwh5lp28zqfanw025mipf2";
  };

  buildInputs = [
    libpcap ncurses pcre openssl ncurses
  ];

  nativeBuildInputs = [
    autoconf automake
  ];

  configureFlags = [
    "--with-pcre"
    "--enable-unicode"
    "--enable-ipv6"
    "--enable-eep"
  ];

  preConfigure = "./bootstrap.sh";

  meta = with stdenv.lib; {
    description = "A tool for displaying SIP calls message flows from terminal";
    homepage = "https://github.com/irontec/sngrep";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jorise ];
  };
}
