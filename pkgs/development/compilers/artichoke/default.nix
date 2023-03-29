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
    version = "73f8bd2f4c30bd7057b7f471b8928d6312440d06";

    src = fetchFromGitHub {
      owner = "artichoke";
      repo = "artichoke";
      rev = "${version}";
      sha256 = "sha256-osog4kYkgwQ1szqBmKvJwHPksnmvbTbjFvDEcTa9tRo=";
    };

    cargoSha256 = "sha256-3XiWi/yxlG+zNe3SUhhIOIIUQKQ5CBlrkG1lV9MHuKc=";

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
      maintainers = [(import ../../../../maintainers/maintainer-list.nix).craun];
    };
  }
