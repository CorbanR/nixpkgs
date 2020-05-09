# nixpkgs
[![Build Status](https://github.com/CorbanR/nixpkgs/workflows/Nixpkgs/badge.svg)](https://github.com/CorbanR/nixpkgs/actions)

Custom overrides, derivations, and other helpful nix expressions.

## Branches
**gh-pages:** Where the nix cache is deployed to. Fronted by cloudflare and a cloudflare worker that proxies gitlfs assests.

**cg-worker:** The cloudflare worker code.

**master:** Custom overrides, derivations, and other helpful nix expressions.

## Adding channel
add channel with `raunco` alias

```bash
nix-channel --add https://nixpkgs.raunco.co/ raunco
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

# Adds to the list that already contains https://cache.nixos.org
{
  nix.binaryCaches = [
    https://nixpkgs.raunco.co/cache
  ];

  nix.binaryCachePublicKeys = [
    nixpkgs.raunco.co:bb6Y8BB7fkbRlhaUFzbubClYT5OlHyqEmCG8uh9Kt2U=
  ];
}

```

#### Example Usage
Using `nix-env` you can install a package from this channel by running something like `nix-env -iA raunco.nodejs-8_x`,
or install using nix configuration. The example below, uses [home-manager](https://github.com/rycee/home-manager)

```
{ ... }:

let
  raunco = import <raunco> {};
in
  {
    home.packages = [
      raunco.vaulted
      raunco.rapture
    ];
  }
```

# Developing
You can see the github actions located in .github/workflows/nix.yml. This action should test, build and deploy the cache.
Eventually I would like to setup the docker/vagrant local testing with nix expressions!

## Local testing
Tools needed:
  - docker
  - docker-compose
  - vagrant(osx testing)
  - virtualbox (used by vagrant)

For now, you can test via docker, docker-compose, and vagrant(for osx)

Example Docker:
  ```bash
  # Get into a nix-ubuntu container where you can install / test building / test the channel etc
  docker-compose run --rm nix-ubuntu /bin/bash

  # Get into a nix container that is closer to nixos
  docker-compose run --rm nix /bin/sh
  ```

Example Vagrant:
  ```bash
  # Start osx machine
  vagrant up
  ```
