{ fetchurl
, javaVersion ? "11"
, graalvmVersion ? "20.2.0" }:

let
  base = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${graalvmVersion}";
in
  {
    x86_64-darwin = {
      "11" = {
        graalvm = fetchurl {
          url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
          sha256 = "e9df2caace6f90fcfbc623c184ef1bbb053de20eb4cf5b002d708c609340ba7a";
        };
        native-image = fetchurl {
          url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "d60c321d6e680028f37954121eeebff0839a0a49a4436e5b41c636c3dd951de3";
        };
        llvm-toolchain = fetchurl {
          url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "239804e1a37f754f191e039f28aa26437604749a6e3390086f65397e8435ea99";
        };
        wasm = fetchurl {
          url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "f07182c354b137262d793a4558a7437f800c63fb189000e395081341926ebcfe";
        };
      };
      "8" = {
        graalvm = fetchurl {
          url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
          sha256 = "a1f524788354cfd2434566f0de972372f4a7743919bae49a9d508f2080385e7b";
        };
        native-image = fetchurl {
          url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "4852abafe92e13cb6bf655bba4ba36721b93324ccc6777504f34c70094c583fb";
        };
        llvm-toolchain = fetchurl {
          url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "a0f91f97ffc736d4f3eb084ccf7c230ffb4749b1ce27a1bac3833ff15a01ba7b";
        };
        wasm = fetchurl {
          url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "75d9b0ec960804cfd196caaabeb0ca3f094a02aa621b54cd20d7523cd5fda3d5";
        };
      };
    };
  }
