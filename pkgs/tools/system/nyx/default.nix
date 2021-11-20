{ stdenv
, lib
, pkgs
, fetchFromGitHub
, libyaml
, openssl
, version ? "1.9.7"
, sha256 ? "12p9n6wfnvgm6pqin6aammipfgd0rwrvbdbrzm711986jrk9cky5"
, withPlugins ? false
, }:

let

  src = fetchFromGitHub {
    inherit sha256;
    owner = "kongo2002";
    repo = "nyx";
    rev = "v${version}";
  };

in
  stdenv.mkDerivation rec {
    pname = "nyx";
    inherit version src;

    buildInputs = [ libyaml openssl ];
    makeFlags = [ "PREFIX=$(out)" "SSL=1" ] ++ lib.optional withPlugins [ "PLUGINS=1" ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/nyx --run sleep 20
    sleep 3
    $out/bin/nyx stop __run__
    $out/bin/nyx quit
    '';

    meta = with lib; {
      homepage = "https://github.com/kongo2002/nyx";
      description = "Lean linux and OSX process monitoring written in C";

      platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" ];
      license = licenses.asl20;
      maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
    };
  }
