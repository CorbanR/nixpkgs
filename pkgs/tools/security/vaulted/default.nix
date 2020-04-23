{ stdenv, buildGoModule, fetchFromGitHub, makeWrapper, enableWrapper ? true}:

buildGoModule rec {
  pname = "vaulted";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "miquella";
    repo = "vaulted";
    rev = "v${version}";
    sha256 = "1pimcpl9karl9lmyyc6xdjb4sn3j3gwj16666kdiqfjvi85naldj";
  };

  modSha256 = "0rnxzv77fm3h0caaj7dgfbgy2z96ssn3vymp9bhbbdv54dqqjg1y";

  # Since vaulted spawns a new shell /etc/profile gets called(at leas on OSX), which calls path_helper, which screws with the path
  # unsetting __NIX_DARWIN_SET_ENVIRONMENT_DONE makes it so nix paths(such as run/current-system/sw/bin)  come before /bin /usr/bin etc.
  nativeBuildInputs = stdenv.lib.optionals (enableWrapper && stdenv.isDarwin) [ makeWrapper ];
  postInstall = ''''+ stdenv.lib.optionalString (enableWrapper && stdenv.isDarwin) ''
    wrapProgram $out/bin/vaulted --set __NIX_DARWIN_SET_ENVIRONMENT_DONE ""
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/miquella/vaulted";
    description = "Spawning and storage of secure environments";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
  };
}
