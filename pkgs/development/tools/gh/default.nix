{ lib, buildGoModule, fetchFromGitHub, writeText, installShellFiles, pkgs }:

buildGoModule rec {
  pname = "gh";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1nrbz049nizrrfxdpws05gj0bqk47l4mrl4wcvfb6nwispc74ib0";
  };

  vendorSha256 = "0j2jy7n7hca5ybwwgh7cvm77j96ngaq1a1l5bl70vjpd8hz2qapc";

  nativeBuildInputs = [ installShellFiles pkgs.git];

  # upstream unsets these to handle cross but it breaks our build
  postPatch = ''
    substituteInPlace Makefile \
      --replace "GOOS= GOARCH= GOARM= GOFLAGS= CGO_ENABLED=" ""
  '';

  buildPhase = ''
    runHook preBuild
    make GO_LDFLAGS="-s -w" GH_VERSION=${version} bin/gh manpages
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/gh -t $out/bin
    installManPage share/man/*/*.[1-9]
    for shell in bash fish zsh; do
      $out/bin/gh completion -s $shell > gh.$shell
      installShellCompletion gh.$shell
    done
    runHook postInstall
  '';

  doCheck = false;
  #checkPhase = ''
    #make test
  #'';

  meta = with lib; {
    homepage = "https://cli.github.com/";
    description = "GitHub’s official command line tool";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
