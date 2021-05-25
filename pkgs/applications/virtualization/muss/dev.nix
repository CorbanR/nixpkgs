{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "muss";
  #TODO add a script to automatically do this(prefetch and update from latest master)
  version = "548d2c42e84d5090ff44a0bcd08dfc2430e59c52";

  src = fetchFromGitHub {
    owner = "get-bridge";
    repo = "muss";
    rev = "${version}";
    sha256 = "0xbwzjxzrlrrb5a6k038zphci4bldjzpy600slnc9k694asmqdqg";
  };

  doCheck = false;
  vendorSha256 = "01p79qwrj2kqwkc7bpljrilpb4aglxfl7ksnmj8mscscpl8as13y";

  buildFlagsArray = ''
    -ldflags=
       -X github.com/get-bridge/muss/cmd.Version=${version}
  '';

  buildFlags = [ "-tags netgo" ];

  meta = with lib; {
    homepage = "https://github.com/get-bridge/muss";
    description = "For when your docker-compose projects are a mess";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
