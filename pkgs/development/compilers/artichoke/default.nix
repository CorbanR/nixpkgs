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
  version = "b2968d9dbb74823811f39fea38b6fa76924fa3f5";

  cargoPatches = [ ./cargo_feature.patch ];
  #patches = [ ./cargo_feature.patch ];

  src = fetchFromGitHub {
    owner = "artichoke";
    repo = "artichoke";
    rev = "${version}";
    sha256 = "1c4w3awal7i1ry0ba1z3my8vxbj22i5khp5x0wk14hdmm6aa7g1l";
  };

  cargoSha256 = "0vbcqq8xf19if7ry3vwfv1k6rxygwkcbvmk52bl03fnvpaia69q6";

  nativeBuildInputs = [rust-bin.nightly.latest.minimal mruby ruby rake rustfmt rust-bindgen];

  doInstallCheck = true;
  installCheckPhase = ''
      echo ${
        lib.escapeShellArg ''
          puts "Okie Dokie Artichokie"
        ''
      } > okie.rb
      $out/bin/artichoke okie.rb

      # run on JVM with Graal Compiler
      #$out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld | fgrep 'Hello World'

      # Ahead-Of-Time compilation
      #$out/bin/native-image -H:-CheckToolchain -H:+ReportExceptionStackTraces --no-server HelloWorld
      #./helloworld | fgrep 'Hello World'


    '';

  meta = with lib; {
    description = "Ruby implementation written in Rust";
    homepage = "https://github.com/artichoke/artichoke";
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
