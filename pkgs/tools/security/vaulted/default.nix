{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper, enableWrapper ? true}:

buildGoModule rec {
  pname = "vaulted";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "miquella";
    repo = "vaulted";
    rev = "v${version}";
    sha256 = "1pimcpl9karl9lmyyc6xdjb4sn3j3gwj16666kdiqfjvi85naldj";
  };

  vendorSha256 = "1zj807wjaz2gy8hhva1vf67h6zr1vnmliv70h7w3arl0nk6rpch5";

  # Since vaulted spawns a new shell /etc/profile gets called(at least on OSX), which calls path_helper, which screws with the path
  # unsetting some environment variables makes it so nix paths(such as run/current-system/sw/bin) come before /bin /usr/bin.
  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals enableWrapper [ makeWrapper ];
  postInstall = ''
    installManPage doc/man/*

  ''+ lib.optionalString enableWrapper ''
    wrapProgram $out/bin/vaulted \
      --set __ETC_BASHRC_SOURCED "" \
      --set __ETC_ZPROFILE_SOURCED  "" \
      --set __ETC_ZSHENV_SOURCED "" \
      --set __ETC_ZSHRC_SOURCED "" \
      ${lib.optionalString (enableWrapper && stdenv.isDarwin)
      ''--set __NIX_DARWIN_SET_ENVIRONMENT_DONE ""''}
  '';

  meta = with lib; {
    homepage = "https://github.com/miquella/vaulted";
    description = "Spawning and storage of secure environments";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
