{ pkgs ? import <nixpkgs> {}, ... }:

let
  hello = pkgs.callPackage ./. {};
in
  pkgs.runCommand "hello" {
    buildInputs = [ hello ];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    hello | grep -i "Hello, world!"  &> /dev/null || expected "Hello, world!"
    hello > $out
  ''
