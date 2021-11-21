{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "muss";
  #TODO add a script to automatically do this(prefetch and update from latest master)
  version = "e94f1e61625a97de7bfb0c673578073087302b87";

  src = fetchFromGitHub {
    owner = "get-bridge";
    repo = "muss";
    rev = "${version}";
    sha256 = "11s4qvy2c9qdbfa57f4k4f3z7z6ml8apd2q8vn0bdd8cgkavh5v6";
  };

  doCheck = false;
  vendorSha256 = "01p79qwrj2kqwkc7bpljrilpb4aglxfl7ksnmj8mscscpl8as13y";

  ldflags = ["-X github.com/get-bridge/muss/cmd.Version=${version}"];
  tags = ["netgo"];

  meta = with lib; {
    homepage = "https://github.com/get-bridge/muss";
    description = "For when your docker-compose projects are a mess";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
