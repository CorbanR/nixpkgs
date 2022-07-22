{
  lib,
  rustPlatform,
  rust-bindgen,
  rustfmt,
  mruby,
  clippy,
  ruby,
  rake,
  fetchFromGitHub
}:

with import <nixpkgs> {
  overlays = [
    (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
  ];
};


rustPlatform.buildRustPackage rec {
  pname = "artichoke";
  version = "f86225f2256b51939d7a2ea0c73ddb36a99f64ab";

  src = fetchFromGitHub {
    owner = "artichoke";
    repo = "artichoke";
    rev = "${version}";
    sha256 = "1076zjl1r1w17yaini9dmfmj7w3ak6wgmrzibf49d9fddjj2i81v";
  };

  cargoSha256 = "sha256-vqu5jx4u3/GCjredj5r6POmYrKQNttlRmsN668Nj6zw=";

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
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
