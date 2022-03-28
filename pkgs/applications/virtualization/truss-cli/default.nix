{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "truss-cli";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "get-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "sha256-qJJ/XWDvwJT29VBjwN1dO2YZ1IVm2yLl4wiW5UdsRyU=";
  };

  doCheck = false;

  vendorSha256 = "sha256-rebeCbzgxJT5+QB3nPYcYQYgEYQTr6H8Uh4M3w0Mj9g=";
  ldflags = ["-s -w -X github.com/get-bridge/truss-cli/cmd.Version=${version}"];

  meta = with lib; {
    homepage = "https://github.com/get-bridge/truss-cli";
    description = "CLI to help you manage many k8s clusters";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
