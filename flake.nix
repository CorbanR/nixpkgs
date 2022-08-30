{
  description = "Raunco Nix Channel";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {inherit system;};
        raunco = import ./default.nix {inherit system pkgs;};
      in {
        legacyPackages = raunco;
      }
    );
}
