{ pkgs ? import <nixpkgs> {}, ... }:

let
  gh = pkgs.callPackage ./. {};
in
  pkgs.runCommand "gh" {
    buildInputs = [ gh ];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    gh --version | grep "" &> /dev/null || expected "Some output yo"
    gh --version > $out
  ''
