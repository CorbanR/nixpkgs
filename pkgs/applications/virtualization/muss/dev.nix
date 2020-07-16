{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "muss";
  #TODO add a script to automatically do this(prefetch and update from latest master)
  version = "69de67689ebeeb75e41a102897787dc5474062b7";

  src = fetchFromGitHub {
    owner = "instructure";
    repo = "muss";
    rev = "${version}";
    sha256 = "0prnadwvbx5y4pjqiksa92djdmzws3995yl40638rp8zc3ivbasy";
  };

  vendorSha256 = "01p79qwrj2kqwkc7bpljrilpb4aglxfl7ksnmj8mscscpl8as13y";

  buildFlagsArray = ''
    -ldflags=
       -X gerrit.instructure.com/muss/cmd.Version=${version}
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
