{
  stdenv,
  lib,
  callPackage,
  fetchurl,
  unzip,
  version ? (
    if stdenv.isDarwin
    then "2.17.6"
    else ""
  ),
}:
# Upstream nix appears to only support linux.
# So, if were on osx, use the custom derivation, otherwise use upstream
if stdenv.isDarwin
then callPackage ./dart.nix {inherit stdenv fetchurl unzip version;}
else
  # If using Linux proxy to Upstream nix derivation
  # Upstream maintains different versions by default.
  # So we ony want to use version if it's been explicitly set.
  let
    options = {inherit stdenv fetchurl unzip;} // lib.optionalAttrs (version != "") {inherit version;};
  in
    callPackage <nixpkgs/pkgs/development/interpreters/dart> options
