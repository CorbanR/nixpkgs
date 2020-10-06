{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "truss-cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "instructure-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "02pgsrznkwhvi32gfnvwnys14inbbwgbv2mjh158pb6r57d31i1y";
  };

  doCheck = false;

  vendorSha256 = "1rgf4lykl3ay04l1hgj8xys8w8s9wsv7ixbsgr45l4i6gr9ha7p1";

  meta = with stdenv.lib; {
    homepage = "https://github.com/instructure-bridge/truss-cli";
    description = "CLI to help you manage many k8s clusters";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
