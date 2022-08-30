{pkgs ? import <nixpkgs> {}, ...}: let
  rapture = pkgs.callPackage ./. {};
in
  pkgs.runCommand "rapture"
  {
    buildInputs = [rapture];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    rapture version | grep "" &> /dev/null || expected "Some output yo"
    rapture version > $out
  ''
