{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "truss-cli";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "instructure-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "17fxzmzfsb2jz21w2miy6qb6i021782s724jvj3jlbgxgl6qk632";
  };

  vendorSha256 = "1v6337rpkgsz8x5y09i0sfccwpqxwglgv0lnrwz83gal5qqb6pf8";

  meta = with stdenv.lib; {
    homepage = "https://github.com/instructure-bridge/truss-cli";
    description = "CLI to help you manage many k8s clusters";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
