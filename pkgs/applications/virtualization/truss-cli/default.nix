{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "truss-cli";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "instructure-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "0v7bgs5da9j7wl5w9ck80rww67xf079kkd4hx8k3p575gq5pfzan";
  };

  doCheck = false;

  vendorSha256 = "1kqvw85l6jqk69j399aqrrjcf9sgbqx34javqqzbvq26dj4i42qs";
  buildFlagsArray = [ "-ldflags= -s -w -X github.com/instructure-bridge/truss-cli/cmd.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/instructure-bridge/truss-cli";
    description = "CLI to help you manage many k8s clusters";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
