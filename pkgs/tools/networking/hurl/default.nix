{ stdenv
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
, libxml2
, openssl
, curl
, pkgconfig
, Security
, bash
, python3
, gzip
, coreutils-full
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "1.0.0";

  # for cargo test to work, there are some prequisites, that don't make sense in this context to install
  # see https://github.com/Orange-OpenSource/hurl/blob/master/.github/workflows/ci.yml#L27
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    echo "GET https://www.google.com" | $out/bin/hurl &> /dev/null
  '';

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    sha256 = "1h6vv4yl5q6xlqakbd8kgrljmvb69lmvndbq0mharf28bap01ilc";
  };

  cargoSha256 = "0wddz1ng8pbg9b1mqvadhmgq3ns09plvjsvlp7ij8nran61h6887";

  nativeBuildInputs = [ asciidoctor installShellFiles pkgconfig bash python3 gzip coreutils-full ];
  buildInputs = [ libxml2 openssl curl  ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  preFixup = ''
    patchShebangs ci/man.sh
    patchShebangs ci/gen_manpage.py
    bash ci/man.sh
    installManPage target/man/hurl.1.gz
    installManPage target/man/hurlfmt.1.gz
  '';

  meta = with stdenv.lib; {
    description = "Hurl, run and test HTTP requests";
    homepage = "hurl.dev";
    license = licenses.asl20;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
