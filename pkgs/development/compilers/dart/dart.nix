{
  stdenv,
  lib,
  fetchurl,
  writeTextFile,
  unzip,
  version ? "2.19.6",
}: let
  # Add a little helper script to start the dart language server
  # See https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md
  dartLspServer = writeTextFile {
    name = "dartlspserver";
    text = builtins.readFile ./dartlspserver;
    executable = true;
  };

  sources = let
    base = "https://storage.googleapis.com/dart-archive/channels";
    stable_version = "stable";
    beta_version = "beta";
    dev_version = "dev";
  in {
    "2.19.6-x86_64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "999a66d6d67aef780a5cf455bdf551133587e79e7853a962412e4c79affa95da";
    };
    "3.0.0-290.3.beta-x86_64-darwin" = fetchurl {
      url = "${base}/${beta_version}/release/${version}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "6adcd14258e50d852b873ca8888e224d520af44d971ecbf44c6ccb1138a2efbc";
    };
    "3.0.0-369.0.dev-x86_64-darwin" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "54bc7a12c1672abc9643c9beb4568b0e3bf82d3966a38cc75030be1c42ea3418";
    };

    "2.19.6-aarch64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "3c6b54b6f44bca38bdc7858ea45734f297951eba5fb10c8fa7b86b4a3f43edb6";
    };
    "3.0.0-290.3.beta-aarch64-darwin" = fetchurl {
      url = "${base}/${beta_version}/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "d8ba093d655b3cedfa3398105b9ce820c8452c0086061c8fb3bbd7cfee8023dc";
    };
    "3.0.0-369.0.dev-aarch64-darwin" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "4a42b7ad9914b67b5056a59f04f9ceab8c306a5a33e5bf898e0fc667b2d58383";
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

        #$out/bin/dart compile exe main.dart -o hello
      '';

      meta = {
        homepage = "https://www.dartlang.org/";
        maintainers = [(import ../../../../maintainers/maintainer-list.nix).craun];
        description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
        longDescription = ''
          Dart is a class-based, single inheritance, object-oriented language
          with C-style syntax. It offers compilation to JavaScript, interfaces,
          mixins, abstract classes, reified generics, and optional typing.
        '';
        platforms = ["x86_64-darwin" "aarch64-darwin"];
        license = licenses.bsd3;
      };
    }
