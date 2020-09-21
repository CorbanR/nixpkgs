{ pkgs, callPackage }:

with pkgs;
let
  isDarwin = pkgs.system == "x86_64-darwin";

  # Packages that are darwin only for now
  darwinPlatformPackages = {
    graalvm11-ce-bin = callPackage ../development/compilers/graalvm/test-bin.nix { javaVersion = "11"; }; # See installCheckPhase
    graalvm8-ce-bin = callPackage ../development/compilers/graalvm/test-bin.nix { javaVersion = "8"; }; # See installCheckPhase
  };

  crossPlatformPackages = {
    _nyx = callPackage ../tools/system/nyx {}; # name conflics with another nix package hence _nyx; See installCheckPhase
    dart = callPackage ../development/interpreters/dart {}; # See installCheckPhase
    github-cli = callPackage ../development/tools/gh/test.nix {};
    goaccess = callPackage ./pkgs/tools/misc/goaccess {};
    hello = callPackage ./hello/test.nix {};
    libpulsar = callPackage ../development/libraries/libpulsar {}; # See installCheckPhase
    muss = callPackage ../applications/virtualization/muss/test.nix {};
    muss-dev = callPackage ../applications/virtualization/muss/test-dev.nix {};
    nodejs-8_x = callPackage ../development/web/nodejs-8_x/test.nix {};
    rapture = callPackage ../tools/security/rapture/test.nix {};
    truss-cli = callPackage ../applications/virtualization/truss-cli/test.nix {};
    vaulted = callPackage ../tools/security/vaulted/test.nix {};
    xmlsec-openssl = callPackage ../development/libraries/xmlsec-openssl/test.nix {};
  };

  tests = {} // (if isDarwin then (crossPlatformPackages // darwinPlatformPackages) else crossPlatformPackages);

in tests
