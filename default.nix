{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> {},
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isx86_64 = pkgs.stdenv.hostPlatform.isx86_64;

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  x86_64-darwinOnly = {};

  # Packages that are darwin only for now
  darwinPlatformPackages = {
    dart_stable = callPackage ./pkgs/development/compilers/dart {};
    dart_beta = callPackage ./pkgs/development/compilers/dart {version = "3.2.0-210.1.beta";};
    dart_dev = callPackage ./pkgs/development/compilers/dart {version = "3.2.0-236.0.dev";};
    artichoke = callPackage ./pkgs/development/compilers/artichoke {};
  };

  crossPlatformPackages = rec {
    dart = callPackage ./pkgs/development/compilers/dart {};
    muss = callPackage ./pkgs/applications/virtualization/muss {};
    muss-dev = callPackage ./pkgs/applications/virtualization/muss/dev.nix {};
    rapture = callPackage ./pkgs/tools/security/rapture {};
    truss-cli = callPackage ./pkgs/applications/virtualization/truss-cli {};
    vaulted = vaulted-wrapped;
    vaulted-unwrapped = callPackage ./pkgs/tools/security/vaulted {enableWrapper = false;};
    vaulted-wrapped = callPackage ./pkgs/tools/security/vaulted {enableWrapper = true;};
    xmlsec-openssl = callPackage ./pkgs/development/libraries/xmlsec-openssl {};
  };

  self = {} // crossPlatformPackages // pkgs.lib.optionalAttrs isDarwin darwinPlatformPackages // pkgs.lib.optionalAttrs isx86_64 x86_64-darwinOnly;
in
  self
