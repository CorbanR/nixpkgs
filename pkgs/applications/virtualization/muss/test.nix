{ pkgs ? import <nixpkgs> {}, ... }:

let
  muss = pkgs.callPackage ./. {};
in
  pkgs.runCommand "muss" {
    buildInputs = [ muss ];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    muss help | grep "" &> /dev/null || expected "Some output yo"
    muss help > $out
  ''
