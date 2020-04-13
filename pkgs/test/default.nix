{ pkgs, callPackage }:

with pkgs;

{
  hello = callPackage ../development/hello/test.nix {};
  nodejs-8_x = callPackage ../development/web/nodejs-8_x {};
}
