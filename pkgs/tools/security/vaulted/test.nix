{pkgs ? import <nixpkgs> {}, ...}: let
  wrapped-vaulted = pkgs.callPackage ./. {};
  unwrapped-vaulted = pkgs.callPackage ./. {enableWrapper = false;};
in {
  wrapped-command =
    pkgs.runCommand "wrapped-vaulted" {
      buildInputs = [wrapped-vaulted pkgs.which];
    } ''
      expected () {
      echo "Test expectation failed: $@"
      exit 1
      }

      vaulted version | grep "" &> /dev/null || expected "Some output yo"
      grep __NIX_DARWIN_SET_ENVIRONMENT_DONE $(which vaulted) &> /dev/null || expected "Expected a wrapper"
      vaulted version > $out
    '';

  unwrapped-command =
    pkgs.runCommand "unwrapped-vaulted" {
      buildInputs = [unwrapped-vaulted pkgs.which];
    } ''
      expected () {
      echo "Test expectation failed: $@"
      exit 1
      }

      vaulted version | grep "" &> /dev/null || expected "Some output yo"

      if grep -q __NIX_DARWIN_SET_ENVIRONMENT_DONE $(which vaulted); then
        expected "Did not expect a wrapper"
      fi
      vaulted version > $out
    '';
}
