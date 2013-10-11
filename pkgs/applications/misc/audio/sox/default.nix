{ composableDerivation, lib, fetchurl, alsaLib, libao, lame, libmad, flac, libvorbis }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} {
  name = "sox-14.3.0";

  src = fetchurl {
    url = mirror://sourceforge/sox/sox-14.3.0.tar.gz;
    sha256 = "15r39dq9nlwrypm0vpxmbxyqqv0bd6284djbi1fdfrlkjhf43gws";
  };

  enableParallelBuilding = true;

  flags =
    # are these options of interest? We'll see
    #--disable-fftw          disable usage of FFTW
    #--enable-debug          enable debugging
    #--disable-cpu-clip      disable tricky cpu specific clipper
    edf { name = "alsa"; enable = { buildInputs = [alsaLib]; }; }
    // edf { name = "libao"; enable = { buildInputs = [libao]; }; }
    // edf { name = "oss"; }
    // edf { name = "sun_audio"; }
    // edf { name = "dl-lame"; enable.buildInputs = [ lame ]; } # use shared library
    // edf { name = "lame";    enable.buildInputs = [ lame ]; }
    // edf { name = "dl-mad"; enable.buildInputs = [ libmad ]; } # use shared library
    // edf { name = "mad";    enable.buildInputs =[ libmad ]; }
    // edf { name = "flac";   enable.buildInputs =[ flac ]; }
    // edf { name = "oggvorbis";   enable.buildInputs =[ libvorbis ]; }
    ;

  cfg = {
    ossSupport = false;
    sun_audioSupport = false;
    flacSupport = true;
    oggSupport = true;
  } // lib.listToAttrs
    [ { name = "dl-lameSupport"; value = true; }
      { name = "dl-madSupport"; value = true; }
    ];

  configureFlags = ["-enable-dl-lame"];

  optionals = [ "libsndfile" "libogg" "flac" "ffmpeg" "libmad" "lame"
                 /* "amr-wb" "amr-nb" */
                "libsamplerate" /* "ladspa" */ ];

  meta = {
    description = "Sample Rate Converter for audio";
    homepage = http://www.mega-nerd.com/SRC/index.html;
    maintainers = [lib.maintainers.marcweber];
    # you can choose one of the following licenses:
    license = [
      "GPL"
      # http://www.mega-nerd.com/SRC/libsamplerate-cul.pdf
      "libsamplerate Commercial Use License"
    ];
  };
}
