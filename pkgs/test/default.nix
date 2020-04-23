{ pkgs, callPackage }:

with pkgs;

{
  hello = callPackage ./hello/test.nix {};
  nodejs-8_x = callPackage ../development/web/nodejs-8_x/test.nix {};
  rapture = callPackage ../tools/security/rapture/test.nix {};
  vaulted = callPackage ../tools/security/vaulted/test.nix {};
  xmlsec-openssl = callPackage ../development/libraries/xmlsec-openssl/test.nix {};
}
