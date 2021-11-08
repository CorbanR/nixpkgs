{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  isDarwin = system == "x86_64-darwin";

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  # Packages that are darwin only for now
  darwinPlatformPackages = {
    dart_stable = callPackage ./pkgs/development/interpreters/dart {};
    dart_beta = callPackage ./pkgs/development/interpreters/dart {version="2.12.0-29.10.beta";};
    dart_dev = callPackage ./pkgs/development/interpreters/dart {version="2.12.0-79.0.dev";};
    graalvm11-ce-bin = callPackage ./pkgs/development/compilers/graalvm/graalvm-ce-bin.nix { javaVersion = "11"; };
    graalvm8-ce-bin = callPackage ./pkgs/development/compilers/graalvm/graalvm-ce-bin.nix { javaVersion = "8"; };
    nodejs-8_x = callPackage ./pkgs/development/web/nodejs-8_x {}; # Not sure what broke this package in Ubuntu.. but moving here for now as I primarily use this on OSX only
  };

  crossPlatformPackages = rec {
    _nyx = callPackage ./pkgs/tools/system/nyx {}; # name conflics with another nix package hence _nyx
    artichoke = callPackage ./pkgs/development/compilers/artichoke {};
    dart = callPackage ./pkgs/development/interpreters/dart {};
    goaccess = callPackage ./pkgs/tools/misc/goaccess {};
    hurl = callPackage ./pkgs/tools/networking/hurl { inherit (pkgs.darwin.apple_sdk.frameworks) Security; };
    libpulsar = callPackage ./pkgs/development/libraries/libpulsar {};
    muss = callPackage ./pkgs/applications/virtualization/muss {};
    muss-dev = callPackage ./pkgs/applications/virtualization/muss/dev.nix {};
    rapture = callPackage ./pkgs/tools/security/rapture {};
    truss-cli = callPackage ./pkgs/applications/virtualization/truss-cli {};
    vaulted = vaulted-wrapped;
    vaulted-unwrapped = callPackage ./pkgs/tools/security/vaulted { enableWrapper = false; };
    vaulted-wrapped = callPackage ./pkgs/tools/security/vaulted { enableWrapper = true; };
    xmlsec-openssl = callPackage ./pkgs/development/libraries/xmlsec-openssl {};
  };

  self = {} // (if isDarwin then (crossPlatformPackages // darwinPlatformPackages) else crossPlatformPackages);
in self
