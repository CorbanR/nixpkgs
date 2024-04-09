{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  enableWrapper ? true,
}:
buildGoModule rec {
  pname = "vaulted";
  version = "v3.1.unstable";

  src = fetchFromGitHub {
    owner = "CorbanR";
    repo = "vaulted";
    rev = "eb7dbfda3f44be229fe92102bb975e706339b377";
    sha256 = "033n3088m4dcvhmqiblkpfmibrw75miq4153wd7nhh7r256qnc18";
  };

  doCheck = false;
  vendorHash = "sha256-oQwPDx2dru4EMiSTuvhvo6P03m7Dw3hHab8c6a9kKkQ=";

  # Since vaulted spawns a new shell /etc/profile gets called(at least on OSX), which calls path_helper, which screws with the path
  # unsetting some environment variables makes it so nix paths(such as run/current-system/sw/bin) come before /bin /usr/bin.
  nativeBuildInputs = [installShellFiles] ++ lib.optionals enableWrapper [makeWrapper];
  postInstall =
    ''
      installManPage doc/man/*

    ''
    + lib.optionalString enableWrapper ''
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
    maintainers = [(import ../../../../maintainers/maintainer-list.nix).craun];
  };
}
