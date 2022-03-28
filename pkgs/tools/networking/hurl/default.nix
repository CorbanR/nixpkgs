{ stdenv
, lib
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
  version = "1.6.1";

  # for cargo test to work, there are some prequisites, that don't make sense in this context to install
  # see https://github.com/Orange-OpenSource/hurl/blob/master/.github/workflows/ci.yml#L27
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/hurl --version
  '';
  #installCheckPhase = ''
    #echo "GET https://www.google.com" | $out/bin/hurl &> /dev/null
  #'';

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    sha256 = "sha256-ud4ARpiyMcYwPKsLbeK4MMBLzkD/tecF1L1vWyYpKmY=";
  };

  cargoHash = "sha256-tmHP7xwVce/hh8nX1LO/zwPIlDZkICPMlBjZjuv37xU=";

  nativeBuildInputs = [ asciidoctor installShellFiles pkgconfig bash python3 gzip coreutils-full ];
  buildInputs = [ libxml2 openssl curl  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  preFixup = ''
    patchShebangs ci/man.sh
    patchShebangs ci/gen_manpage.py
    bash ci/man.sh
    installManPage target/man/hurl.1.gz
    installManPage target/man/hurlfmt.1.gz
  '';

  meta = with lib; {
    description = "Hurl, run and test HTTP requests";
    homepage = "hurl.dev";
    license = licenses.asl20;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
