{ pkgs ? import <nixpkgs> {}, ... }:

let
  muss-dev = pkgs.callPackage ./dev.nix {};
in
  pkgs.runCommand "muss-dev" {
    buildInputs = [ muss-dev ];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    muss help | grep "" &> /dev/null || expected "Some output yo"
    muss help > $out
  ''
