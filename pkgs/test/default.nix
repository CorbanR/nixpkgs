{ pkgs, callPackage }:

with pkgs;
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isx86_64 = pkgs.stdenv.hostPlatform.isx86_64;

  x86_64-darwinOnly = {
    # nodejs-8_x = callPackage ../development/web/nodejs-8_x/test.nix {};
  };

  # Packages that are darwin only for now
  darwinPlatformPackages = {
    graalvm11-ce-bin = callPackage ../development/compilers/graalvm/test-bin.nix { javaVersion = "11"; }; # See installCheckPhase
    graalvm8-ce-bin = callPackage ../development/compilers/graalvm/test-bin.nix { javaVersion = "8"; }; # See installCheckPhase
  };

  crossPlatformPackages = {
    _nyx = callPackage ../tools/system/nyx {}; # name conflics with another nix package hence _nyx; See installCheckPhase
    artichoke = callPackage ../development/compilers/artichoke {}; # See installCheckPhase
    dart = callPackage ../development/interpreters/dart {}; # See installCheckPhase
    goaccess = callPackage ../tools/misc/goaccess {};
    hello = callPackage ./hello/test.nix {};
    hurl = callPackage ../tools/networking/hurl { inherit (darwin.apple_sdk.frameworks) Security; };
    muss = callPackage ../applications/virtualization/muss/test.nix {};
    muss-dev = callPackage ../applications/virtualization/muss/test-dev.nix {};
    rapture = callPackage ../tools/security/rapture/test.nix {};
    terraform_0_12 = callPackage ../applications/networking/cluster/terraform/test.nix {};
    truss-cli = callPackage ../applications/virtualization/truss-cli/test.nix {};
    vaulted = callPackage ../tools/security/vaulted/test.nix {};
    xmlsec-openssl = callPackage ../development/libraries/xmlsec-openssl/test.nix {};
  };

  tests = {} // crossPlatformPackages // pkgs.lib.optionalAttrs isDarwin darwinPlatformPackages // pkgs.lib.optionalAttrs isx86_64 x86_64-darwinOnly;

in tests
