# nixpkgs
Custom overrides, derivations, and other helpful nix expressions.

## Adding channel
```bash
nix-channel --add https://nixpkgs.raunco.co/
nix-channel --update
```

### Adding channel cache
To enable the cache, the channel must be setup as a substituter. To add in user configuration
Add the following to `~/.config/nix/nix.conf`(create the file if it doesn't exist)
See the nix manual for more information / options such as using [extra-substituters](https://nixos.org/nix/manual/#conf-extra-substituters)

```bash
  substituters = https://cache.nixos.org https://nixpkgs.raunco.co/cache
  trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs.raunco.co:bb6Y8BB7fkbRlhaUFzbubClYT5OlHyqEmCG8uh9Kt2U=
```

If using [nix-darwin](https://github.com/LnL7/nix-darwin) custom caches can be added for all users via
[nix.binaryCachePublicKeys](https://lnl7.github.io/nix-darwin/manual/index.html#opt-nix.binaryCachePublicKeys) 
and [nix.binaryCaches](https://lnl7.github.io/nix-darwin/manual/index.html#opt-nix.binaryCaches) (There is also option
[nix.trustedBinaryCaches](https://lnl7.github.io/nix-darwin/manual/index.html#opt-nix.trustedBinaryCaches))

Example: `darwin-configuration.nix`

```
{ config, lib, pkgs, options, ... }:


{
  nix.binaryCaches = [
    https://cache.nixos.org
    https://nixpkgs.raunco.co/cache
  ];

  nix.binaryCachePublicKeys = [
    cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
    nixpkgs.raunco.co:bb6Y8BB7fkbRlhaUFzbubClYT5OlHyqEmCG8uh9Kt2U=
  ];
}

```
