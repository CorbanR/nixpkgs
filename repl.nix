let
  flake = builtins.getFlake (toString ./.);
  #nixpkgs = import <nixpkgs> { system = "x86_64-darwin";};
  nixpkgs = import <nixpkgs> {};
in
  {inherit flake;}
  // flake
  // builtins
  // nixpkgs
  // nixpkgs.lib
#// flake.nixosConfigurations

