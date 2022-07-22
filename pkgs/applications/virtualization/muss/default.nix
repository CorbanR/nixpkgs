{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "muss";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "get-bridge";
    repo = "muss";
    rev = "v${version}";
    sha256 = "1qp0c2l4s7mx3w9gx385l9wypswmwykp05kvx9kfq3s7a597bm44";
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
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
