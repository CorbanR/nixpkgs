{ pkgs, callPackage }:

with pkgs;

{
  hello = callPackage ./hello/test.nix {};
  nodejs-8_x = callPackage ../development/web/nodejs-8_x {};
  xmlsec-openssl = callPackage ../development/libraries/xmlsec-openssl {};
}
