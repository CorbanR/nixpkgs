{ stdenv, fetchurl, writeTextFile, unzip, version ? "2.8.4" }:

let
  # Add a little helper script to start the dart language server
  # See https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md
  dartLspServer =  writeTextFile {
    name = "dartlspserver";
    text = (builtins.readFile ./dartlspserver);
    executable = true;
  };

  sources = let

    base = "https://storage.googleapis.com/dart-archive/channels";
    stable_version = "stable";
    beta_version = "beta";
    dev_version = "dev";
    x86_64 = "x64";

  in {
    "2.8.4-x86_64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "0f576e249e22f61301d46a5bde267f08a330a1ad0954be348a10e44e43bdd94c";
    };
    "2.9.0-8.2.beta-x86_64-darwin" = fetchurl {
      url = "${base}/${beta_version}/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "aea422e0104c65657103e23baa0b6ffdd2883c05e48eccfcf5aab605ffb8c02c";
    };
    "2.9.0-13.0.dev-x86_64-darwin" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "0467ffeb06503f794e5d55a7bfdb52c831e483d03ba41758c16eccda5f2a0289";
    };
  };

in

with stdenv.lib;

stdenv.mkDerivation {

  pname = "dart";
  inherit version;

  nativeBuildInputs = [
    unzip
  ];

  src = sources."${version}-${stdenv.hostPlatform.system}" or (throw "unsupported version/system: ${version}/${stdenv.hostPlatform.system}");

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    cp ${dartLspServer} $out/bin/dartlspserver
  '';

  dontStrip = true;

  doInstallCheck = true;
  installCheckPhase = ''
    echo ${stdenv.lib.escapeShellArg ''
      void main() {
        print('Hello, World!');
      }
      ''} > main.dart
    $out/bin/dart main.dart

    $out/bin/dart2native main.dart -o hello
    ./hello
  '';

  meta = {
    homepage = "https://www.dartlang.org/";
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
    description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
    longDescription = ''
      Dart is a class-based, single inheritance, object-oriented language
      with C-style syntax. It offers compilation to JavaScript, interfaces,
      mixins, abstract classes, reified generics, and optional typing.
    '';
    platforms = [ "x86_64-darwin" ];
    license = licenses.bsd3;
  };
}
