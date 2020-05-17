{ stdenv
,callPackage
,fetchurl
,unzip
,version ? (if stdenv.isDarwin then "2.8.1" else "") }:

# Upstream nix appears to only support linux.
# So, if were on osx, use the custom derivation, otherwise use upstream
if stdenv.isDarwin then
callPackage ./dart.nix { inherit stdenv fetchurl unzip version; }
else
# Upstream maintains different versions by default.
# So we ony want to use version if it's been explicitly set.
let
  options = { inherit stdenv fetchurl unzip; } // stdenv.lib.optionalAttrs (version != "") {inherit version;};
in
callPackage <nixpkgs/pkgs/development/interpreters/dart> options