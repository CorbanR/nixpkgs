{ stdenv, fetchurl, writeTextFile, unzip, version ? "2.9.3" }:

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
    "2.9.3-x86_64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "f29ff9955b024bcf2aa6ffed6f8f66dc37a95be594496c9a2d695e67ac34b7ac";
    };
    "2.10.0-110.5.beta-x86_64-darwin" = fetchurl {
      url = "${base}/${beta_version}/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "a80aed10942fda812646a8cf5bcc57ff62d55f2055994c91ade86bee905396fe";
    };
    "2.10.0-110.0.dev-x86_64-darwin" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "f9ee3241424aca8d76f366997dcabb8db889586e660940e84249bbb669794cb7";
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
