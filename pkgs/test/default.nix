{
  pkgs,
  callPackage,
}:
with pkgs; let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isx86_64 = pkgs.stdenv.hostPlatform.isx86_64;

  x86_64-darwinOnly = {};

  # Packages that are darwin only for now
  darwinPlatformPackages = {};

  crossPlatformPackages = {
    artichoke = callPackage ../development/compilers/artichoke {}; # See installCheckPhase
    dart = callPackage ../development/compilers/dart {}; # See installCheckPhase
    hello = callPackage ./hello/test.nix {};
    muss = callPackage ../applications/virtualization/muss/test.nix {};
    muss-dev = callPackage ../applications/virtualization/muss/test-dev.nix {};
    rapture = callPackage ../tools/security/rapture/test.nix {};
    truss-cli = callPackage ../applications/virtualization/truss-cli/test.nix {};
    vaulted = callPackage ../tools/security/vaulted/test.nix {};
    xmlsec-openssl = callPackage ../development/libraries/xmlsec-openssl/test.nix {};
  };

  tests = {} // crossPlatformPackages // pkgs.lib.optionalAttrs isDarwin darwinPlatformPackages // pkgs.lib.optionalAttrs isx86_64 x86_64-darwinOnly;
in
  tests
