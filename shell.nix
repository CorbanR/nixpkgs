{ pkgs ? import <nixpkgs> {}, ...}:

with pkgs;

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices Security;
  darwin_packages = [ CoreServices ApplicationServices Security];

  nodejs = nodejs-14_x;
  nodePackages = pkgs.nodePackages.override {inherit nodejs;};

  nodePkgs = with nodePackages; [
    typescript
  ];

  ruby = ruby_2_7;
  rakeVersion = { version = "13.0.3"; pname = "rake"; source.sha256 = "1iik52mf9ky4cgs38fp2m8r6skdkq1yz23vh18lk95fhbcxb6a67"; };
  rubyPackages = ruby.withPackages (ps: with ps; [ (rake.override rakeVersion ) pry ]);

in mkShell rec {
  name = "raunco.nixpkgs";

  buildInputs = [
    nodejs
    wrangler
    rubyPackages
  ] ++ nodePkgs ++ lib.optional stdenv.isDarwin darwin_packages;

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
