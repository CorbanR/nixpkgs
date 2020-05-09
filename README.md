# cf-worker

Cloudflare worker that proxies my gitlfs files to their respective locations in https://media.githubusercontent.com

# deploying
Ensure you have [nix](https://nixos.org/download.html), [lorri](https://github.com/target/lorri), and [direnv](https://direnv.net/).

- `direnv allow` the folder, lorri should then setup your `nix-shell`
- `wrangler build`
- `wrangler publish` will publish to [https://rewrite.corban.workers.dev](https://rewrite.corban.workers.dev)
- `wrangler publish --env production` will publish the route on [https://nixpkgs.raunco.co/cache/](https://nixpkgs.raunco.co/cache/)
