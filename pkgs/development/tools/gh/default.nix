{ stdenv, buildGoModule, fetchFromGitHub, writeText, installShellFiles, pkgs }:

buildGoModule rec {
  pname = "gh";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "17hbgi1jh4p07r4p5mr7w7p01i6zzr28mn5i4jaki7p0jwfqbvvi";
  };

  vendorSha256 = "0ybbwbw4vdsxdq4w75s1i0dqad844sfgs69b3vlscwfm6g3i9h51";

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
