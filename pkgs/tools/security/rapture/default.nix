{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rapture";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "daveadams";
    repo = "go-rapture";
    rev = "v${version}";
    sha256 = "0r1alk2nkv5cyk4j2cdgih4zy82x55svhq8l6q7p9nl4m4xkz9ka";
  };

  modSha256 = "0l6rlhcmqlh6kaxmbg1461mr793bzvh0aizy8hi1w05dxz5d48gk";

  meta = with stdenv.lib; {
    homepage = "https://github.com/daveadams/go-rapture";
    description = "Shell-integrated CLI for assuming AWS IAM roles";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.publicDomain;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
