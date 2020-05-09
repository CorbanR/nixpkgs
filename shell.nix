{ pkgs ? import <nixpkgs> {}, ...}:

with pkgs;

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices Security;
  darwin_packages = [ CoreServices ApplicationServices Security];

  nodejs = nodejs-12_x;
  nodePackages = pkgs.nodePackages.override {inherit nodejs;};

  nodePkgs = with nodePackages; [
    typescript
  ];

in mkShell rec {
  name = "raunco.nixpkgs";

  buildInputs = [
    nodejs
    cloudflare-wrangler
  ] ++ nodePkgs ++ stdenv.lib.optional stdenv.isDarwin darwin_packages;

  shellHook = ''
    # Add additional folders to to XDG_DATA_DIRS if they exists, which will get sourced by bash-completion
    for p in ''${buildInputs}; do
      if [ -d "$p/share/bash-completion" ]; then
        XDG_DATA_DIRS="$XDG_DATA_DIRS:$p/share"
      fi
    done

    source ${bash-completion}/etc/profile.d/bash_completion.sh
  '';
}
