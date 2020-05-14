/* Expression taken from upstram nixpkg repository
   https://github.com/NixOS/nixpkgs/tree/master/maintainers

   List of NixOS maintainers.
    ```nix
    handle = {
      # Required
      name = "Your name";
      email = "address@example.org";
      # Optional
      github = "GithubUsername";
      githubId = your-github-id;
      keys = [{
        longkeyid = "rsa2048/0x0123456789ABCDEF";
        fingerprint = "AAAA BBBB CCCC DDDD EEEE  FFFF 0000 1111 2222 3333";
      }];
    };
    ```
    where
    - `handle` is the handle you are going to use in nixpkgs expressions,
    - `name` is your, preferably real, name,
    - `email` is your maintainer email address, and
    - `github` is your GitHub handle (as it appears in the URL of your profile page, `https://github.com/<userhandle>`),
    - `githubId` is your GitHub user ID, which can be found at `https://api.github.com/users/<userhandle>`,
    - `keys` is a list of your PGP/GPG key IDs and fingerprints.
    `handle == github` is strongly preferred whenever `github` is an acceptable attribute name and is short and convenient.
    Add PGP/GPG keys only if you actually use them to sign commits and/or mail.
    To get the required PGP/GPG values for a key run
    ```shell
    gpg --keyid-format 0xlong --fingerprint <email> | head -n 2
    ```
    !!! Note that PGP/GPG values stored here are for informational purposes only, don't use this file as a source of truth.
    More fields may be added in the future.
    Please keep the list alphabetically sorted.
    See `./scripts/check-maintainer-github-handles.sh` for an example on how to work with this data.
*/
rec{
  "CorbanR" = {
    email = "corban@raunco.co";
    name = "Corban Raun";
    github = "CorbanR";
    githubId = 1918683;
    keys = [{
      longkeyid = "rsa4096/0xA697A56F1F151189";
      fingerprint = "6607 0B24 8CE5 64ED 22CE  0950 A697 A56F 1F15 1189";
    }];
  };

  "craun" = CorbanR;
}
