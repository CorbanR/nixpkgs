{
  stdenv,
  lib,
  fetchurl,
  writeTextFile,
  unzip,
  version ? "3.1.3",
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
    "3.1.3-x86_64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "ddadd6bf48675440fa683afddc771f0917adba5e58adc5bd5261c1a2bcf47201";
    };
    "3.2.0-210.1.beta-x86_64-darwin" = fetchurl {
      url = "${base}/${beta_version}/release/${version}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "f8de231b80d74c211a6849d20326596042ae921c87f31d6041c0f9e3858cbe48";
    };
    "3.2.0-236.0.dev-x86_64-darwin" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-macos-x64-release.zip";
      sha256 = "8b85b2575e8fd4c47bf65f40a94b1d9d82e805fdeeca40aea2db44c1087850ac";
    };

    "3.1.3-aarch64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "795ad45899ff4004403ed6aa998181f10936cbf6c8d7125e8d1dad6fb3d35659";
    };
    "3.2.0-210.1.beta-aarch64-darwin" = fetchurl {
      url = "${base}/${beta_version}/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "8b2cee0df8199d6868b3160ead16cbe463434f0d6fdf4ed15b70ae0d17f6c120";
    };
    "3.2.0-236.0.dev-aarch64-darwin" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-macos-arm64-release.zip";
      sha256 = "618a436fe9e1c26d0d9797004c7e55c3a73f36532437e30dec076e4ca80ab3e3";
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
