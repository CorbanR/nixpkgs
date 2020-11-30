{ stdenv, buildGoModule, fetchFromGitHub, writeText, installShellFiles, pkgs }:

buildGoModule rec {
  pname = "gh";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1d15nrba53yk75n610wnyziq9x5v515i8pqi97iyrsz2gm2lbi3p";
  };

  vendorSha256 = "009dv2brr4h71z78cxikgm0az3hxh28mwm94kn2sgx3pd4r5gir5";

  nativeBuildInputs = [ installShellFiles pkgs.git];

  buildPhase = ''
    export GO_LDFLAGS="-s -w"
    make GH_VERSION=${version} bin/gh manpages
  '';

  installPhase = ''
    install -Dm755 bin/gh -t $out/bin
    installManPage share/man/*/*.[1-9]
    for shell in bash fish zsh; do
      $out/bin/gh completion -s $shell > gh.$shell
      installShellCompletion gh.$shell
    done
  '';

  checkPhase = ''
    make test
  '';

  meta = with stdenv.lib; {
    homepage = "https://cli.github.com/";
    description = "GitHub’s official command line tool";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
