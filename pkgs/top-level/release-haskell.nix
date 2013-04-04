/* Essential Haskell packages that must build. */

{ nixpkgs ? { outPath = (import ./all-packages.nix {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; } }:

let supportedSystems = [ "x86_64-linux" ]; in

with import ./release-lib.nix { inherit supportedSystems; };

mapTestOn {
  gitAndTools.gitAnnex = supportedSystems;

  jhc = supportedSystems;

  haskellPackages_ghc742 = {
    abstractPar = supportedSystems;
    ACVector = supportedSystems;
    aeson = supportedSystems;
    AgdaExecutable = supportedSystems;
    alex = supportedSystems;
    alexMeta = supportedSystems;
    alternativeIo = supportedSystems;
    ansiTerminal = supportedSystems;
    ansiWlPprint = supportedSystems;
    asn1Data = supportedSystems;
    AspectAG = supportedSystems;
    async = supportedSystems;
    attempt = supportedSystems;
    attoparsecEnumerator = supportedSystems;
    attoparsec = supportedSystems;
    authenticate = supportedSystems;
    base64Bytestring = supportedSystems;
    baseUnicodeSymbols = supportedSystems;
    benchpress = supportedSystems;
    bimap = supportedSystems;
    binaryShared = supportedSystems;
    bitmap = supportedSystems;
    bktrees = supportedSystems;
    blazeBuilderEnumerator = supportedSystems;
    blazeBuilder = supportedSystems;
    blazeHtml = supportedSystems;
    blazeTextual = supportedSystems;
    bloomfilter = supportedSystems;
    bmp = supportedSystems;
    BNFC = supportedSystems;
    BNFCMeta = supportedSystems;
    Boolean = supportedSystems;
    bytestringMmap = supportedSystems;
    bytestringNums = supportedSystems;
    bytestringTrie = supportedSystems;
    cabal2Ghci = supportedSystems;
    cabal2nix = supportedSystems;
    cabalDev = supportedSystems;
    cabalGhci = supportedSystems;
    cabalInstall = supportedSystems;
    cairo = supportedSystems;
    caseInsensitive = supportedSystems;
    cautiousFile = supportedSystems;
    cereal = supportedSystems;
    certificate = supportedSystems;
    cgi = supportedSystems;
    Chart = supportedSystems;
    citeprocHs = supportedSystems;
    clientsession = supportedSystems;
    cmdargs = supportedSystems;
    cmdlib = supportedSystems;
    colorizeHaskell = supportedSystems;
    colour = supportedSystems;
    comonadsFd = supportedSystems;
    conduit = supportedSystems;
    ConfigFile = supportedSystems;
    continuedFractions = supportedSystems;
    converge = supportedSystems;
    convertible = supportedSystems;
    cookie = supportedSystems;
    cpphs = supportedSystems;
    cprngAes = supportedSystems;
    criterion = supportedSystems;
    cryptoApi = supportedSystems;
    cryptocipher = supportedSystems;
    cryptohash = supportedSystems;
    Crypto = supportedSystems;
    cssText = supportedSystems;
    csv = supportedSystems;
    darcs = supportedSystems;
    dataAccessor = supportedSystems;
    dataAccessorTemplate = supportedSystems;
    dataDefault = supportedSystems;
    dataenc = supportedSystems;
    dataReify = supportedSystems;
    datetime = supportedSystems;
    DAV = supportedSystems;
    dbus = supportedSystems;
    derive = supportedSystems;
    diagrams = supportedSystems;
    Diff = supportedSystems;
    digestiveFunctorsHeist = supportedSystems;
    digestiveFunctorsSnap = supportedSystems;
    digest = supportedSystems;
    dimensional = supportedSystems;
    dimensionalTf = supportedSystems;
    directoryTree = supportedSystems;
    distributedProcess = supportedSystems;
    dlist = supportedSystems;
    dns = supportedSystems;
    doctest = supportedSystems;
    dotgen = supportedSystems;
    doubleConversion = supportedSystems;
    Ebnf2ps = supportedSystems;
    editDistance = supportedSystems;
    editline = supportedSystems;
    emailValidate = supportedSystems;
    entropy = supportedSystems;
    enumerator = supportedSystems;
    epic = supportedSystems;
    erf = supportedSystems;
    failure = supportedSystems;
    fclabels = supportedSystems;
    feed = supportedSystems;
    fgl = supportedSystems;
    fileEmbed = supportedSystems;
    filestore = supportedSystems;
    fingertree = supportedSystems;
    flexibleDefaults = supportedSystems;
    funcmp = supportedSystems;
    gamma = supportedSystems;
    gdiff = supportedSystems;
    ghcEvents = supportedSystems;
    ghc = supportedSystems;
    ghcMtl = supportedSystems;
    ghcPaths = supportedSystems;
    ghcSybUtils = supportedSystems;
    githubBackup = supportedSystems;
    github = supportedSystems;
    gitit = supportedSystems;
    glade = supportedSystems;
    glib = supportedSystems;
    Glob = supportedSystems;
    gloss = supportedSystems;
    GLUT = supportedSystems;
    gnutls = supportedSystems;
    graphviz = supportedSystems;
    gtk = supportedSystems;
    gtksourceview2 = supportedSystems;
    hackageDb = supportedSystems;
    haddock = supportedSystems;
    hakyll = supportedSystems;
    hamlet = supportedSystems;
    happstackHamlet = supportedSystems;
    happstackServer = supportedSystems;
    happstackUtil = supportedSystems;
    happy = supportedSystems;
    hashable = supportedSystems;
    hashedStorage = supportedSystems;
    haskeline = supportedSystems;
    haskellLexer = supportedSystems;
    haskellPlatform = supportedSystems;
    haskellSrcExts = supportedSystems;
    haskellSrc = supportedSystems;
    haskellSrcMeta = supportedSystems;
    HaXml = supportedSystems;
    haxr = supportedSystems;
    HDBC = supportedSystems;
    HDBCPostgresql = supportedSystems;
    HDBCSqlite3 = supportedSystems;
    HFuse = supportedSystems;
    highlightingKate = supportedSystems;
    hinotify = supportedSystems;
    hint = supportedSystems;
    Hipmunk = supportedSystems;
    hledgerInterest = supportedSystems;
    hledgerLib = supportedSystems;
    hledger = supportedSystems;
    hledgerWeb = supportedSystems;
    hlint = supportedSystems;
    HList = supportedSystems;
    hmatrix = supportedSystems;
    hoogle = supportedSystems;
    hopenssl = supportedSystems;
    hostname = supportedSystems;
    hp2anyCore = supportedSystems;
    hp2anyGraph = supportedSystems;
    hS3 = supportedSystems;
    hscolour = supportedSystems;
    hsdns = supportedSystems;
    hsemail = supportedSystems;
    hslogger = supportedSystems;
    hsloggerTemplate = supportedSystems;
    hspec = supportedSystems;
    hspread = supportedSystems;
    HsSyck = supportedSystems;
    HStringTemplate = supportedSystems;
    hsyslog = supportedSystems;
    html = supportedSystems;
    httpConduit = supportedSystems;
    httpDate = supportedSystems;
    httpdShed = supportedSystems;
    HTTP = supportedSystems;
    httpTypes = supportedSystems;
    HUnit = supportedSystems;
    hxt = supportedSystems;
    IfElse = supportedSystems;
    irc = supportedSystems;
    iteratee = supportedSystems;
    jailbreakCabal = supportedSystems;
    json = supportedSystems;
    jsonTypes = supportedSystems;
    lambdabot = supportedSystems;
    languageCQuote = supportedSystems;
    languageJavascript = supportedSystems;
    largeword = supportedSystems;
    lens = supportedSystems;
    libxmlSax = supportedSystems;
    liftedBase = supportedSystems;
    ListLike = supportedSystems;
    logfloat = supportedSystems;
    ltk = supportedSystems;
    mainlandPretty = supportedSystems;
    maude = supportedSystems;
    MaybeT = supportedSystems;
    MemoTrie = supportedSystems;
    mersenneRandomPure64 = supportedSystems;
    mimeMail = supportedSystems;
    MissingH = supportedSystems;
    mmap = supportedSystems;
    MonadCatchIOMtl = supportedSystems;
    MonadCatchIOTransformers = supportedSystems;
    monadControl = supportedSystems;
    monadLoops = supportedSystems;
    monadPar = supportedSystems;
    monadPeel = supportedSystems;
    MonadPrompt = supportedSystems;
    MonadRandom = supportedSystems;
    mpppc = supportedSystems;
    mtl = supportedSystems;
    mtlparse = supportedSystems;
    multiplate = supportedSystems;
    multirec = supportedSystems;
    multiset = supportedSystems;
    murmurHash = supportedSystems;
    mwcRandom = supportedSystems;
    nat = supportedSystems;
    nats = supportedSystems;
    naturals = supportedSystems;
    networkInfo = supportedSystems;
    network = supportedSystems;
    networkMulticast = supportedSystems;
    networkProtocolXmpp = supportedSystems;
    nonNegative = supportedSystems;
    numericPrelude = supportedSystems;
    numtype = supportedSystems;
    numtypeTf = supportedSystems;
    ObjectName = supportedSystems;
    OneTuple = supportedSystems;
    OpenAL = supportedSystems;
    OpenGL = supportedSystems;
    packunused = supportedSystems;
    pandoc = supportedSystems;
    pandocTypes = supportedSystems;
    pango = supportedSystems;
    parallel = supportedSystems;
    parseargs = supportedSystems;
    parsec3 = supportedSystems;
    parsec = supportedSystems;
    parsimony = supportedSystems;
    pathPieces = supportedSystems;
    pathtype = supportedSystems;
    pcreLight = supportedSystems;
    permutation = supportedSystems;
    persistent = supportedSystems;
    persistentPostgresql = supportedSystems;
    persistentSqlite = supportedSystems;
    persistentTemplate = supportedSystems;
    polyparse = supportedSystems;
    ppm = supportedSystems;
    prettyShow = supportedSystems;
    primitive = supportedSystems;
    PSQueue = supportedSystems;
    pureMD5 = supportedSystems;
    pwstoreFast = supportedSystems;
    QuickCheck2 = supportedSystems;
    QuickCheck = supportedSystems;
    randomFu = supportedSystems;
    random = supportedSystems;
    randomShuffle = supportedSystems;
    randomSource = supportedSystems;
    RangedSets = supportedSystems;
    ranges = supportedSystems;
    readline = supportedSystems;
    recaptcha = supportedSystems;
    regexBase = supportedSystems;
    regexCompat = supportedSystems;
    regexPCRE = supportedSystems;
    regexPosix = supportedSystems;
    regexpr = supportedSystems;
    regexTDFA = supportedSystems;
    regular = supportedSystems;
    RSA = supportedSystems;
    rvar = supportedSystems;
    safe = supportedSystems;
    SafeSemaphore = supportedSystems;
    SDLImage = supportedSystems;
    SDL = supportedSystems;
    SDLMixer = supportedSystems;
    SDLTtf = supportedSystems;
    semigroups = supportedSystems;
    sendfile = supportedSystems;
    shake = supportedSystems;
    SHA = supportedSystems;
    Shellac = supportedSystems;
    shelly = supportedSystems;
    simpleSendfile = supportedSystems;
    smallcheck = supportedSystems;
    SMTPClient = supportedSystems;
    snapCore = supportedSystems;
    snap = supportedSystems;
    snapLoaderStatic = supportedSystems;
    snapServer = supportedSystems;
    split = supportedSystems;
    splot = supportedSystems;
    srcloc = supportedSystems;
    stateref = supportedSystems;
    StateVar = supportedSystems;
    statistics = supportedSystems;
    stbImage = supportedSystems;
    stm = supportedSystems;
    storableComplex = supportedSystems;
    storableRecord = supportedSystems;
    streamproc = supportedSystems;
    strictConcurrency = supportedSystems;
    strict = supportedSystems;
    strptime = supportedSystems;
    svgcairo = supportedSystems;
    syb = supportedSystems;
    sybWithClassInstancesText = supportedSystems;
    sybWithClass = supportedSystems;
    tabular = supportedSystems;
    tagged = supportedSystems;
    tagsoup = supportedSystems;
    tar = supportedSystems;
    Tensor = supportedSystems;
    terminfo = supportedSystems;
    testFramework = supportedSystems;
    testpack = supportedSystems;
    texmath = supportedSystems;
    text = supportedSystems;
    thLift = supportedSystems;
    timeplot = supportedSystems;
    tlsExtra = supportedSystems;
    tls = supportedSystems;
    transformersBase = supportedSystems;
    transformersCompat = supportedSystems;
    transformers = supportedSystems;
    tuple = supportedSystems;
    typeLlevelNaturalNumber = supportedSystems;
    uniplate = supportedSystems;
    uniqueid = supportedSystems;
    unixCompat = supportedSystems;
    unorderedContainers = supportedSystems;
    url = supportedSystems;
    utf8Light = supportedSystems;
    utf8String = supportedSystems;
    utilityHt = supportedSystems;
    uuagc = supportedSystems;
    uuid = supportedSystems;
    uulib = supportedSystems;
    vacuumCairo = supportedSystems;
    vacuum = supportedSystems;
    vcsRevision = supportedSystems;
    Vec = supportedSystems;
    vectorAlgorithms = supportedSystems;
    vector = supportedSystems;
    vectorSpace = supportedSystems;
    vty = supportedSystems;
    waiAppStatic = supportedSystems;
    waiExtra = supportedSystems;
    wai = supportedSystems;
    waiLogger = supportedSystems;
    warp = supportedSystems;
    wlPprintExtras = supportedSystems;
    wlPprint = supportedSystems;
    wlPprintTerminfo = supportedSystems;
    wxcore = supportedSystems;
    wxdirect = supportedSystems;
    wx = supportedSystems;
    X11 = supportedSystems;
    xhtml = supportedSystems;
    xmlConduit = supportedSystems;
    xmlHamlet = supportedSystems;
    xml = supportedSystems;
    xmlTypes = supportedSystems;
    xmobar = supportedSystems;
    xmonadContrib = supportedSystems;
    xmonadExtras = supportedSystems;
    xmonad = supportedSystems;
    xssSanitize = supportedSystems;
    yesodAuth = supportedSystems;
    yesodCore = supportedSystems;
    yesodDefault = supportedSystems;
    yesodForm = supportedSystems;
    yesodJson = supportedSystems;
    yesod = supportedSystems;
    yesodPersistent = supportedSystems;
    yesodStatic = supportedSystems;
    zeromq3Haskell = supportedSystems;
    zeromqHaskell = supportedSystems;
    zipArchive = supportedSystems;
    zipper = supportedSystems;
    zlibBindings = supportedSystems;
    zlibEnum = supportedSystems;
    zlib = supportedSystems;
  };

  haskellPackages_ghc762 = {
    alex = supportedSystems;
    async = supportedSystems;
    BNFC = supportedSystems;
    cabal2nix = supportedSystems;
    cabalDev = supportedSystems;
    cabalGhci = supportedSystems;
    cabalInstall = supportedSystems;
    cgi = supportedSystems;
    cmdlib = supportedSystems;
    criterion = supportedSystems;
    dimensional = supportedSystems;
    dimensionalTf = supportedSystems;
    doctest = supportedSystems;
    fgl = supportedSystems;
    funcmp = supportedSystems;
    ghcMod = supportedSystems;
    GLUT = supportedSystems;
    graphviz = supportedSystems;
    hackageDb = supportedSystems;
    haddock = supportedSystems;
    happy = supportedSystems;
    haskellSrc = supportedSystems;
    hledgerInterest = supportedSystems;
    hledgerLib = supportedSystems;
    hledger = supportedSystems;
    hlint = supportedSystems;
    HList = supportedSystems;
    hoogle = supportedSystems;
    hopenssl = supportedSystems;
    hsdns = supportedSystems;
    hsemail = supportedSystems;
    hspec = supportedSystems;
    HStringTemplate = supportedSystems;
    hsyslog = supportedSystems;
    html = supportedSystems;
    HTTP = supportedSystems;
    HUnit = supportedSystems;
    jailbreakCabal = supportedSystems;
    monadPar = supportedSystems;
    mtl = supportedSystems;
    network = supportedSystems;
    OpenGL = supportedSystems;
    pandoc = supportedSystems;
    parallel = supportedSystems;
    parsec = supportedSystems;
    permutation = supportedSystems;
    primitive = supportedSystems;
    QuickCheck = supportedSystems;
    random = supportedSystems;
    regexBase = supportedSystems;
    regexCompat = supportedSystems;
    regexPosix = supportedSystems;
    smallcheck = supportedSystems;
    split = supportedSystems;
    stm = supportedSystems;
    streamproc = supportedSystems;
    syb = supportedSystems;
    tar = supportedSystems;
    testFrameworkHunit = supportedSystems;
    testFramework = supportedSystems;
    text = supportedSystems;
    transformers = supportedSystems;
    uulib = supportedSystems;
    vector = supportedSystems;
    wlPprint = supportedSystems;
    xhtml = supportedSystems;
    xmobar = supportedSystems;
    xmonadContrib = supportedSystems;
    xmonadExtras = supportedSystems;
    xmonad = supportedSystems;
    zlib = supportedSystems;
  };

  haskellPackages_ghc704 = {
    alex = supportedSystems;
    cabal2nix = supportedSystems;
    cabalInstall = supportedSystems;
    cgi = supportedSystems;
    fgl = supportedSystems;
    funcmp = supportedSystems;
    GLUT = supportedSystems;
    haddock = supportedSystems;
    happy = supportedSystems;
    haskellPlatform = supportedSystems;
    haskellSrc = supportedSystems;
    hopenssl = supportedSystems;
    hsdns = supportedSystems;
    hsemail = supportedSystems;
    hsyslog = supportedSystems;
    html = supportedSystems;
    HTTP = supportedSystems;
    HUnit = supportedSystems;
    # This attribute causes an infinite recursion in Hydra!
    # jailbreakCabal = supportedSystems;
    mtl = supportedSystems;
    network = supportedSystems;
    OpenGL = supportedSystems;
    parallel = supportedSystems;
    parsec = supportedSystems;
    primitive = supportedSystems;
    QuickCheck = supportedSystems;
    regexBase = supportedSystems;
    regexCompat = supportedSystems;
    regexPosix = supportedSystems;
    stm = supportedSystems;
    streamproc = supportedSystems;
    syb = supportedSystems;
    text = supportedSystems;
    transformers = supportedSystems;
    vector = supportedSystems;
    xhtml = supportedSystems;
    zlib = supportedSystems;
  };

  haskellPackages_ghc6123 = {
    alex = supportedSystems;
    cabal2nix = supportedSystems;
    cabalInstall = supportedSystems;
    cgi = supportedSystems;
    fgl = supportedSystems;
    funcmp = supportedSystems;
    GLUT = supportedSystems;
    haddock = supportedSystems;
    happy = supportedSystems;
    haskellPlatform = supportedSystems;
    haskellSrc = supportedSystems;
    hopenssl = supportedSystems;
    hsdns = supportedSystems;
    hsemail = supportedSystems;
    hsyslog = supportedSystems;
    html = supportedSystems;
    HTTP = supportedSystems;
    HUnit = supportedSystems;
    # This attribute causes an infinite recursion in Hydra!
    # jailbreakCabal = supportedSystems;
    mtl = supportedSystems;
    network = supportedSystems;
    OpenGL = supportedSystems;
    parallel = supportedSystems;
    parsec = supportedSystems;
    primitive = supportedSystems;
    QuickCheck = supportedSystems;
    regexBase = supportedSystems;
    regexCompat = supportedSystems;
    regexPosix = supportedSystems;
    stm = supportedSystems;
    streamproc = supportedSystems;
    text = supportedSystems;
    transformers = supportedSystems;
    vector = supportedSystems;
    xhtml = supportedSystems;
    zlib = supportedSystems;
  };

  haskellPackages_ghc6104 = {
    alex = supportedSystems;
    cabalInstall = supportedSystems;
    cgi = supportedSystems;
    fgl = supportedSystems;
    funcmp = supportedSystems;
    GLUT = supportedSystems;
    haddock = supportedSystems;
    happy = supportedSystems;
    haskellPlatform = supportedSystems;
    haskellSrc = supportedSystems;
    hopenssl = supportedSystems;
    hsdns = supportedSystems;
    hsyslog = supportedSystems;
    html = supportedSystems;
    HTTP = supportedSystems;
    HUnit = supportedSystems;
    # This attribute causes an infinite recursion in Hydra!
    # jailbreakCabal = supportedSystems;
    mtl = supportedSystems;
    network = supportedSystems;
    OpenGL = supportedSystems;
    parallel = supportedSystems;
    parsec = supportedSystems;
    primitive = supportedSystems;
    QuickCheck = supportedSystems;
    regexBase = supportedSystems;
    regexCompat = supportedSystems;
    regexPosix = supportedSystems;
    stm = supportedSystems;
    streamproc = supportedSystems;
    text = supportedSystems;
    transformers = supportedSystems;
    vector = supportedSystems;
    xhtml = supportedSystems;
    zlib = supportedSystems;
  };

}
