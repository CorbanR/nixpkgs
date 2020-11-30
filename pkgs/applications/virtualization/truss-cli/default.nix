{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "truss-cli";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "instructure-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "1w9al6qb9b4z1pf2szv1hqi61n1z2v68bbb9vk2j9kq40znpw5k8";
  };

  doCheck = false;

  vendorSha256 = "1kqvw85l6jqk69j399aqrrjcf9sgbqx34javqqzbvq26dj4i42qs";

  meta = with stdenv.lib; {
    homepage = "https://github.com/instructure-bridge/truss-cli";
    description = "CLI to help you manage many k8s clusters";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
