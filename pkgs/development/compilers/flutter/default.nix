{channel ? "stable"
,pname ? "flutter"
,version ? (if stdenv.isDarwin then "1.17.1" else "")
,sha256Hash ? "598c6341e43421257a57fc17e82f000eb2df3ed9593e6d698fd2a2f62fe1c829"
,filename ? (if stdenv.isDarwin then "flutter_macos_${version}-${channel}.zip" else "")
,stdenv
,fetchurl
,unzip
,callPackage
,recurseIntoAttrs}:

# channel = beta, version = 1.18.0-11.1.pre, sha256Hash = a33d0f96c9f4abd984efa591ee10c502039c186a0719df8b688b6df1e0d79969

# Upstream nix appears to only support linux.
# So, if were on osx, use the custom derivation, otherwise use upstream
if stdenv.isDarwin then
callPackage ./flutter.nix { inherit channel pname version sha256Hash filename stdenv fetchurl unzip; }
else
# If using Linux proxy to Upstream nix derivation
recurseIntoAttrs (callPackage <nixpkgs/pkgs/development/compilers/flutter> {}).${channel}
