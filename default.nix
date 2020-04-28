{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    graalvm11-ce-bin = callPackage ./pkgs/development/compilers/graalvm/graalvm-ce-bin.nix { javaVersion = "11"; };
    graalvm8-ce-bin = callPackage ./pkgs/development/compilers/graalvm/graalvm-ce-bin.nix { javaVersion = "8"; };
    nodejs-8_x = callPackage ./pkgs/development/web/nodejs-8_x {};
    rapture = callPackage ./pkgs/tools/security/rapture {};
    vaulted = callPackage ./pkgs/tools/security/vaulted {};
    vaulted-unwrapped = callPackage ./pkgs/tools/security/vaulted { enableWrapper = false; };
    vaulted-wrapped = callPackage ./pkgs/tools/security/vaulted { enableWrapper = true; };
    xmlsec-openssl = callPackage ./pkgs/development/libraries/xmlsec-openssl {};
  };
in self
