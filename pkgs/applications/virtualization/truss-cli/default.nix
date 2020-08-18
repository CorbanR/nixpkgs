{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "truss-cli";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "instructure-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "098ybbhf418chji39qjf3ksx19dn9594ks06jdy48i3jfifg4h4g";
  };

  vendorSha256 = "0qvsaag2696nda4qm310dx0lnkjjqrlqlf6hb5plnc9zr33r2qjb";

  meta = with stdenv.lib; {
    homepage = "https://github.com/instructure-bridge/truss-cli";
    description = "CLI to help you manage many k8s clusters";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
