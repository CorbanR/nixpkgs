{ pkgs ? import <nixpkgs> {}
, javaVersion ? "11"
, graalvmVersion ? "20.0.0" }:

let
  graalvm-ce = pkgs.callPackage ./graalvm-ce-bin.nix {inherit javaVersion graalvmVersion;};
in
  pkgs.runCommand "graalvm-ce" {
    buildInputs = [ graalvm-ce ];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    java ${if javaVersion == "11"
    then "--version"
    else "-version"} &> $out || expected "Expected version to print"
  ''
