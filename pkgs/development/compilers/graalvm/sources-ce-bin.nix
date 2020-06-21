{ fetchurl
, javaVersion ? "11"
, graalvmVersion ? "20.1.0" }:

let
  base = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${graalvmVersion}";
in
  {
    x86_64-darwin = {
      "11" = {
        graalvm = fetchurl {
          url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
          sha256 = "04efcb7bdd2e94715d0f3fddcc754594da032887e6aec94a3701bd4774d1a92e";
        };
        native-image = fetchurl {
          url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "ebf81045af7408e0eddf879f3ccf0171377e219155bbbe78ed9182c2a290b346";
        };
        llvm-toolchain = fetchurl {
          url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "4480735148dc0621d1e764dfea5228d43a28859191cfbfe00d693619a4e30b08";
        };
        wasm = fetchurl {
          url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "31a04a9c976fd08c368129a3f727128f7eb33fb3d7faee14df86b453563a01cc";
        };
      };
      "8" = {
        graalvm = fetchurl {
          url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
          sha256 = "3b9fd8ce84c9162a188fde88907c66990db22af0ff6ae2c04430113253a9a634";
        };
        native-image = fetchurl {
          url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "a8f975e276485d09d073b3534dcb955cb5e8740292e294cd7a1b4f83c6991e21";
        };
        llvm-toolchain = fetchurl {
          url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "b9935fccd50a4b6a1f9736201b199c47792b5f926971846869689e5aa1c4583b";
        };
        wasm = fetchurl {
          url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "6f1fbe88dbe80dcb658119b692e34bcacefbf884bae18ab49e5d047da6c330b7";
        };
      };
    };
  }
