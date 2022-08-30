{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "rapture";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "daveadams";
    repo = "go-rapture";
    rev = "v${version}";
    sha256 = "0r1alk2nkv5cyk4j2cdgih4zy82x55svhq8l6q7p9nl4m4xkz9ka";
  };

  vendorSha256 = "0d0pbsk66glhd8phdjmvmq0iqmzj56jqz03fk8bshdgj69w966pv";

  meta = with lib; {
    homepage = "https://github.com/daveadams/go-rapture";
    description = "Shell-integrated CLI for assuming AWS IAM roles";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.publicDomain;
    maintainers = [(import ../../../../maintainers/maintainer-list.nix).craun];
  };
}
