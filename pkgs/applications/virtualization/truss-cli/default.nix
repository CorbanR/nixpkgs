{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "truss-cli";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "get-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "sha256-GNs+CGcXcoImYQM3mMfwuATUn4A0gziy7DKtF08krb8=";
  };

  doCheck = false;

  vendorHash = "sha256-9hV4gh6RHsPff9XsFyVybMc5QSe54ZPZjIrPL+HFVBs=";
  ldflags = ["-s -w -X github.com/get-bridge/truss-cli/cmd.Version=${version}"];

  meta = with lib; {
    homepage = "https://github.com/get-bridge/truss-cli";
    description = "CLI to help you manage many k8s clusters";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [(import ../../../../maintainers/maintainer-list.nix).craun];
  };
}
