{ pkgs ? import <nixpkgs> {}, ... }:

let
  truss = pkgs.callPackage ./default.nix {};
in
  pkgs.runCommand "truss" {
    buildInputs = [ truss ];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    truss-cli help | grep "" &> /dev/null || expected "Some output yo"
    truss-cli help > $out
  ''
