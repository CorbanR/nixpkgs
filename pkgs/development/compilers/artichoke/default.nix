{
  lib,
  rustPlatform,
  rust-bindgen,
  rustfmt,
  mruby,
  clippy,
  ruby,
  rake,
  fetchFromGitHub,
}:
with import <nixpkgs> {
  overlays = [
    (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
  ];
};
  rustPlatform.buildRustPackage rec {
    pname = "artichoke";
    version = "7454564203f1a782425f9e82b0b9e258997df118";

    src = fetchFromGitHub {
      owner = "artichoke";
      repo = "artichoke";
      rev = "${version}";
      sha256 = "sha256-JQKydDK/eIJSzQ1RUsxiH/T6Bgr0J+ZkGGcrcD+uhtQ=";
    };

    cargoSha256 = "sha256-/VrXLFcbZcAl0RRVPUgbhw+bzRc9NFHx0bRnK2O+jvc=";
    nativeBuildInputs = [rust-bin.nightly.latest.minimal mruby ruby rake rustfmt rust-bindgen];

    doInstallCheck = true;
    installCheckPhase = ''
      echo ${
        lib.escapeShellArg ''
          puts "Okie Dokie Artichokie"
        ''
      } > okie.rb
      $out/bin/artichoke okie.rb
    '';

    meta = with lib; {
      description = "Ruby implementation written in Rust";
      homepage = "https://github.com/artichoke/artichoke";
      license = licenses.mit;
      platforms = platforms.darwin;
      maintainers = [(import ../../../../maintainers/maintainer-list.nix).craun];
    };
  }
