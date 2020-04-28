{ fetchurl
, javaVersion ? "11"
, graalvmVersion ? "20.0.0" }:

let
  base = "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${graalvmVersion}";
in
  {
    x86_64-linux = {
      "11" = {
        graalvm = fetchurl {
          url = "${base}/graalvm-ce-java${javaVersion}-linux-amd64-${graalvmVersion}.tar.gz";
          sha256 = "d16c4a340a4619d98936754caeb6f49ee7a61d809c5a270e192b91cbc474c726";
        };
        native-image = fetchurl {
          url = "${base}/native-image-installable-svm-java${javaVersion}-linux-amd64-${graalvmVersion}.jar";
          sha256 = "5e110d42a818b14324779b1d3e6ecfc50065ab9cd90e2e6905be5f922500d8c3";
        };
        llvm-toolchain = fetchurl {
          url = "${base}/llvm-toolchain-installable-java${javaVersion}-linux-amd64-${graalvmVersion}.jar";
          sha256 = "76c0059984ca2c47011b5f6b8c7ad9151e882ad2c28060d8e5631716dc64aa69";
        };
        wasm = fetchurl {
          url = "${base}/wasm-installable-svm-java${javaVersion}-linux-amd64-${graalvmVersion}.jar";
          sha256 = "9437313753fee13e79577094be77f4615aac7e3a0dfe3817fe44e344276c5d83";
        };
      };
      "8" = {
        graalvm = fetchurl {
          url = "${base}/graalvm-ce-java${javaVersion}-linux-amd64-${graalvmVersion}.tar.gz";
          sha256 = "16ef8d89f014b4d295b7ca0c54343eab3c7d24e18b2d376665f5b12bb643723d";
        };
        native-image = fetchurl {
          url = "${base}/native-image-installable-svm-java${javaVersion}-linux-amd64-${graalvmVersion}.jar";
          sha256 = "9aee17470ce750eb2454625988c59de86a79b14b811e78085553385bfa7adaff";
        };
        llvm-toolchain = fetchurl {
          url = "${base}/llvm-toolchain-installable-java${javaVersion}-linux-amd64-${graalvmVersion}.jar";
          sha256 = "636a4c71380e0c3d1b27aad63a4925ebae13e3e1d3303b0dea9485fbe9865c61";
        };
        wasm = fetchurl {
          url = "${base}/wasm-installable-svm-java${javaVersion}-linux-amd64-${graalvmVersion}.jar";
          sha256 = "455d68ada02d91234437ffb716a6ba2041afa7405c5be4b0612262306304634b";
        };
      };
    };
    x86_64-darwin = {
      "11" = {
        graalvm = fetchurl {
          url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
          sha256 = "8ba1205bb08cab04f1efc72423674d5816efbc3b22e482709c508788d87a692a";
        };
        native-image = fetchurl {
          url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "f7b53adde9c92fe1fac120eb45bb2fe9aab4000bfd9073673d62bcd6b40999af";
        };
        llvm-toolchain = fetchurl {
          url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "936a4cf43cf11459cdb803c1c753670218cefd0e16b80d4ca09601f9ba8dd749";
        };
        wasm = fetchurl {
          url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "e754299bbba120a4da7d89bf87629a77193cf958ca139e5bfdc4b6d0cea09207";
        };
      };
      "8" = {
        graalvm = fetchurl {
          url = "${base}/graalvm-ce-java${javaVersion}-darwin-amd64-${graalvmVersion}.tar.gz";
          sha256 = "e3d35fdfe4f62022c42029c052f2b8277b3d896496cf45c2e82d251f5d49701a";
        };
        native-image = fetchurl {
          url = "${base}/native-image-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "e42f59bc774b06ebbd8f7defe4460ac5a84aa20d60676f900c7e83b22ef3d4a5";
        };
        llvm-toolchain = fetchurl {
          url = "${base}/llvm-toolchain-installable-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "07c05bb695f65ff935b309d9a134bfb9c0a17fec71800d96046a6ddf167d78a1";
        };
        wasm = fetchurl {
          url = "${base}/wasm-installable-svm-java${javaVersion}-darwin-amd64-${graalvmVersion}.jar";
          sha256 = "ef23a3560550786307b8e2b89c1dd00548beaeae96ecb35ae3a5000a7214ae5f";
        };
      };
    };
  }
