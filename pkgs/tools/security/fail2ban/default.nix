{ stdenv, fetchurl, pythonPackages, unzip, gamin }:

let version = "0.8.6"; in

pythonPackages.buildPythonPackage {
  name = "fail2ban-${version}";
  namePrefix = "";

  src = fetchurl {
    url    = "https://github.com/fail2ban/fail2ban/zipball/${version}";
    name   = "fail2ban-${version}.zip";
    sha256 = "0lbanfshr8kasa1bb7861w3mrm2d0c1bvv4s5703265s8zp5m284";
  };

  buildInputs = [ unzip ];

  pythonPath = [ gamin ];

  preConfigure = ''
    substituteInPlace setup.cfg \
      --replace /usr $out

    substituteInPlace setup.py \
      --replace /etc $out/etc \
      --replace /var $TMPDIR/var \

    for i in fail2ban-client fail2ban-regex fail2ban-server; do
      substituteInPlace $i \
        --replace /usr/share/fail2ban $out/share/fail2ban
    done
    
    for i in config/action.d/sendmail*.conf; do
      substituteInPlace $i \
        --replace /usr/sbin/sendmail sendmail \
        --replace /usr/bin/whois whois
    done
  '';

  doCheck = false;
  
  installCommand = ''
    python setup.py install --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.fail2ban.org/;
    description = "A program that scans log files for repeated failing login attempts and bans IP addresses";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco lovek323 ];
    platforms   = platforms.unix;
  };
}
