{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "muss";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "instructure";
    repo = "muss";
    rev = "v${version}";
    sha256 = "12mglzjbwdsmixnwajzpp9qvhmabcgszyjfcssk0bxs8pk1zvyz6";
  };

  vendorSha256 = "01p79qwrj2kqwkc7bpljrilpb4aglxfl7ksnmj8mscscpl8as13y";

  buildFlagsArray = ''
    -ldflags=
       -X gerrit.instructure.com/muss/cmd.Version=v${version}
  '';

  buildFlags = [ "-tags netgo" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/instructure/muss";
    description = "For when your docker-compose projects are a mess";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
