{ stdenv, lib, fetchurl, writeTextFile, unzip, version ? "2.14.4" }:

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

  in {
    "2.14.4-x86_64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "c900f6ccb62e2f7526f457d00be8fc296e7c2ce9c7653cf007b5a4db7fe9a9ae";
    };
    "2.15.0-268.18.beta-x86_64-darwin" = fetchurl {
      url = "${base}/${beta_version}/release/${version}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "9431110ce02e6a9d45135098642590d04c423a7e6d16ca319945ffe7bd3ad530";
    };
    "2.16.0-21.0.dev-x86_64-darwin" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "414a4fe36bb7d1e9243fc7bda0e0094f7c53adbe1776467fdf70d9e8ee3882df";
    };

    "2.14.4-aarch64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "3abaf0c2d57e05c27c873aaa47b7d88e59c39d5fc78ae9894dfb880fa18945ea";
    };
    "2.15.0-268.18.beta-aarch64-darwin" = fetchurl {
      url = "${base}/${beta_version}/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "8e4dab94e8793e8d84d1b6fe9dac2807ee5ba80c3c34a25fc087cf0d981fcc85";
    };
    "2.16.0-21.0.dev-aarch64-darwin" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "892485c932a89df76b0f448a778ac20ae02bc41a29bdf43b2cc09cca0b978d60";
    };
  };

in

with lib;

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
    echo ${lib.escapeShellArg ''
      void main() {
        print('Hello, World!');
      }
      ''} > main.dart
    $out/bin/dart main.dart

    $out/bin/dart compile exe main.dart -o hello && ./hello
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
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
    license = licenses.bsd3;
  };
}
