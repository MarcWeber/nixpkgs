# This file is autogenerated from update.py in the same directory.
{
  icedtea7 = rec {
    version = "2.5.4";

    url = "http://icedtea.wildebeest.org/download/source/icedtea-${version}.tar.xz";
    sha256 = "1npz2p11i4xy4732rxs8wv209iap0m3m24w3vkh9kj0p4k2gal0v";

    common_url = "http://icedtea.classpath.org/download/drops/icedtea7/${version}";

    bundles = {
      openjdk = rec {
        url = "${common_url}/openjdk.tar.bz2";
        sha256 = "88c92a3cab37446352086876771733229b1602d4f79ef68629a151180652e1f1";
      };

      corba = rec {
        url = "${common_url}/corba.tar.bz2";
        sha256 = "7411fe2df795981124ae2e4da0ddb7d98db0a94c9399a12876be03e7177eaa0b";
      };

      jaxp = rec {
        url = "${common_url}/jaxp.tar.bz2";
        sha256 = "84623e50b69710d12209fc761a49953c78f1a664ff54e022a77e35e25489f2f3";
      };

      jaxws = rec {
        url = "${common_url}/jaxws.tar.bz2";
        sha256 = "4bd38a8121d85c422b425177ce648afdee9da18812c91c5b74939c58db33ab4b";
      };

      jdk = rec {
        url = "${common_url}/jdk.tar.bz2";
        sha256 = "e99b65baf66d8818e3c8fd31d71fbad4ad0ceb0b7fa4c2e0607eca3a40f2ba09";
      };

      langtools = rec {
        url = "${common_url}/langtools.tar.bz2";
        sha256 = "4fd76cbdf18174128863514b4d3997cb623368697bf4f5af6d079dbbcd7b378a";
      };

      hotspot = rec {
        url = "${common_url}/hotspot.tar.bz2";
        sha256 = "4825f8543aa0c065530b05b0a95915a44eea153bbb696d2ffc4b50a398813e34";
      };
    };
  };
}
