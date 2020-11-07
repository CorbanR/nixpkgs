{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "truss-cli";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "instructure-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "0ydmhiz9wmbih8lp3cgvlacmh91fjfyij35w8c2x0wg61zygcw67";
  };

  doCheck = false;

  vendorSha256 = "07hcgf3kh6pd9gd11ixa493i77dmiawsnz4zjyby1wq0slnk0vxc";

  meta = with stdenv.lib; {
    homepage = "https://github.com/instructure-bridge/truss-cli";
    description = "CLI to help you manage many k8s clusters";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
