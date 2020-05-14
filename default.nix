{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  isDarwin = system == "x86_64-darwin";

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  # Packages that are darwin only for now
  darwinPlatformPackages = {
    graalvm11-ce-bin = callPackage ./pkgs/development/compilers/graalvm/graalvm-ce-bin.nix { javaVersion = "11"; };
    graalvm8-ce-bin = callPackage ./pkgs/development/compilers/graalvm/graalvm-ce-bin.nix { javaVersion = "8"; };
  };

  crossPlatformPackages = {
    _nyx = callPackage ./pkgs/tools/system/nyx {}; # name conflics with another nix package hence _nyx
    dart = callPackage ./pkgs/development/interpreters/dart {};
    libpulsar = callPackage ./pkgs/development/libraries/libpulsar {};
    nodejs-8_x = callPackage ./pkgs/development/web/nodejs-8_x {};
    rapture = callPackage ./pkgs/tools/security/rapture {};
    vaulted = callPackage ./pkgs/tools/security/vaulted {};
    vaulted-unwrapped = callPackage ./pkgs/tools/security/vaulted { enableWrapper = false; };
    vaulted-wrapped = callPackage ./pkgs/tools/security/vaulted { enableWrapper = true; };
    xmlsec-openssl = callPackage ./pkgs/development/libraries/xmlsec-openssl {};
  };

  self = {} // (if isDarwin then (crossPlatformPackages // darwinPlatformPackages) else crossPlatformPackages);
in self
