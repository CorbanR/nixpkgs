{ pkgs, callPackage }:

with pkgs;
let
  isDarwin = pkgs.system == "x86_64-darwin";

  # Packages that are darwin only for now
  darwinPlatformPackages = {
    graalvm11-ce-bin = callPackage ../development/compilers/graalvm/test-bin.nix { javaVersion = "11"; }; # Also see installCheckPhase
    graalvm8-ce-bin = callPackage ../development/compilers/graalvm/test-bin.nix { javaVersion = "8"; }; # Also see installCheckPhase
  };

  crossPlatformPackages = {
    hello = callPackage ./hello/test.nix {};
    libpulsar = callPackage ./pkgs/development/libraries/libpulsar {}; # See installCheckPhase
    nodejs-8_x = callPackage ../development/web/nodejs-8_x/test.nix {};
    rapture = callPackage ../tools/security/rapture/test.nix {};
    vaulted = callPackage ../tools/security/vaulted/test.nix {};
    xmlsec-openssl = callPackage ../development/libraries/xmlsec-openssl/test.nix {};
  };

  tests = {} // (if isDarwin then (crossPlatformPackages // darwinPlatformPackages) else crossPlatformPackages);

in tests
