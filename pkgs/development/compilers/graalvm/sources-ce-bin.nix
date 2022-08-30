{
  fetchurl,
  javaVersion ? "11",
  graalvmVersion ? "20.3.0",
}: let
  base = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${graalvmVersion}";
in {
  x86_64-darwin = {
    "11" = {
      graalvm = fetchurl {
        url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
        sha256 = "22b869fbf590c461278efae5e06fdd5ba32b4d5b302da838d9f50cb71aa20d01";
      };
      native-image = fetchurl {
        url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "cef23d81d4a7091307eaf85c3631bac5c7dc0137e6f13dd1611fbe1c697e626e";
      };
      llvm-toolchain = fetchurl {
        url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "4e6a406c1d06b11fc75985c3e2465957362086410564ce27a7c11983d2900eae";
      };
      wasm = fetchurl {
        url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "3aed8d48b97bc081409c147eac6360a98e4bed17a6304dfb8f0970db1dc44be4";
      };
    };
    "8" = {
      graalvm = fetchurl {
        url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
        sha256 = "01e84c44032f8932ed04b2b829e0454973145bf55ddeeeed0ce71220c2213ae7";
      };
      native-image = fetchurl {
        url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "b107b488247779a30ea80a8a19399edae67b662fc1f354178259e5250749c2c7";
      };
      llvm-toolchain = fetchurl {
        url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "d2fc57dfdab69e611cd7ec76787aa088896f4fb2e53297b1d5f9fd1fcdf80dfa";
      };
      wasm = fetchurl {
        url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "585dd2ae726155b92758083eddfceb0928a2b9109e2eb1dc0d8ec10905b1211a";
      };
    };
  };
  # Right now graalvm only supports running on m1 with rosetta2
  # See https://github.com/oracle/graal/issues/2666
  aarch64-darwin = {
    "11" = {
      graalvm = fetchurl {
        url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
        sha256 = "22b869fbf590c461278efae5e06fdd5ba32b4d5b302da838d9f50cb71aa20d01";
      };
      native-image = fetchurl {
        url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "cef23d81d4a7091307eaf85c3631bac5c7dc0137e6f13dd1611fbe1c697e626e";
      };
      llvm-toolchain = fetchurl {
        url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "4e6a406c1d06b11fc75985c3e2465957362086410564ce27a7c11983d2900eae";
      };
      wasm = fetchurl {
        url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "3aed8d48b97bc081409c147eac6360a98e4bed17a6304dfb8f0970db1dc44be4";
      };
    };
    "8" = {
      graalvm = fetchurl {
        url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
        sha256 = "01e84c44032f8932ed04b2b829e0454973145bf55ddeeeed0ce71220c2213ae7";
      };
      native-image = fetchurl {
        url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "b107b488247779a30ea80a8a19399edae67b662fc1f354178259e5250749c2c7";
      };
      llvm-toolchain = fetchurl {
        url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "d2fc57dfdab69e611cd7ec76787aa088896f4fb2e53297b1d5f9fd1fcdf80dfa";
      };
      wasm = fetchurl {
        url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
        sha256 = "585dd2ae726155b92758083eddfceb0928a2b9109e2eb1dc0d8ec10905b1211a";
      };
    };
  };
}
