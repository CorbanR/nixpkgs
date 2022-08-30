{pkgs ? import <nixpkgs> {}, ...}: let
  terraform_0_12 = pkgs.callPackage ./. {};
in
  pkgs.runCommand "test-terraform" {
    buildInputs = [terraform_0_12];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    terraform --version | grep "v0.12.31" &> /dev/null || expected "version v0.12.31"
    terraform --version > $out
  ''
