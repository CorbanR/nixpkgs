{ pkgs ? import <nixpkgs> {}, ... }:

let
  nodejs-8_x = pkgs.callPackage ./. {};
in
  pkgs.runCommand "nodejs-8_x" {
    buildInputs = [ nodejs-8_x ];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    node --version | grep "8" &> /dev/null || expected "Node version 8_X"
    node --version > $out
  ''
