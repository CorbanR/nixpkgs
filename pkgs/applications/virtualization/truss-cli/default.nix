{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "truss-cli";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "get-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "sha256-nHnnH+DNc1zNCzKv07mlSJim7z0Atd7Gl9U/ZWYmfxA=";
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
