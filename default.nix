{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    nodejs-8_x = callPackage ./pkgs/development/web/nodejs-8_x {};
    rapture = callPackage ./pkgs/tools/security/rapture {};
    vaulted = callPackage ./pkgs/tools/security/vaulted {};
    vaulted-unwrapped = callPackage ./pkgs/tools/security/vaulted { enableWrapper = false; };
    vaulted-wrapped = callPackage ./pkgs/tools/security/vaulted { enableWrapper = true; };
    xmlsec-openssl = callPackage ./pkgs/development/libraries/xmlsec-openssl {};
  };
in self
