{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    nodejs-8_x = callPackage ./pkgs/development/web/nodejs-8_x { };
    xmlsec-openssl = callPackage ./pkgs/development/libraries/xmlsec-openssl { };
  };
in self
