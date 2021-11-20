{
  description = "Raunco Nix Channel";

  outputs = { self }: {
    overlay = final: prev: {
      raunco = import ./default.nix {
        rauncopkgs = prev;
        pkgs = prev;
      };
    };
  };
}
