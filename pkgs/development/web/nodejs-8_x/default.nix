{ callPackage, enableNpm ? true, openssl, darwin }:

let
  buildNodejs = callPackage <nixpkgs/pkgs/development/web/nodejs/nodejs.nix> {inherit openssl darwin;};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.17.0";
    sha256 = "5b0d96db482b273f0324c299ead86ecfbc5d033516e5fc37c92cfccb933ef6ff";
  }
