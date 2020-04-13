{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
in
  pkgs.callPackage ./pkgs/test {inherit pkgs;}
