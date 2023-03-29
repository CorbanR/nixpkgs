{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "muss";
  #TODO add a script to automatically do this(prefetch and update from latest master)
  version = "bf280d8e76a4ceec5219e0da5a9b89299ed3c7ef";

  src = fetchFromGitHub {
    owner = "get-bridge";
    repo = "muss";
    rev = "${version}";
    sha256 = "sha256-hNR1UlFHD+xm6nsWcKfnlevreaIFjf4SH70eTahg4OI=";
  };

  doCheck = false;
  vendorSha256 = "sha256-+qTpEdMw5hb3Bm7zguk0WElSJpj1/MpybxOXQZO5P9o=";

  ldflags = ["-X github.com/get-bridge/muss/cmd.Version=${version}"];
  tags = ["netgo"];

  meta = with lib; {
    homepage = "https://github.com/get-bridge/muss";
    description = "For when your docker-compose projects are a mess";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [(import ../../../../maintainers/maintainer-list.nix).craun];
  };
}
