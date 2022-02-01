{ boost17x
, clang
, clang-tools
, cmake
, curl
, enablePython ? false
, fetchurl
, gcc
, gtest ? null
, jsoncpp
, lib
, llvmPackages
, log4cxx ? null
, openssl
, pkg-config
, protobuf
, python3 ? null
, snappy ? null
, stdenv
, zlib ? null
, zstd ? null
}:

let
  /*
    Check if null or false
    Example:
    let result = enableFeature null
    => "OFF"
    let resule = enableFeature false
    => "OFF"
    let result = enableFeature «derivation»
    => "ON"
  */
  enableCmakeFeature = p: if (p == null || p == false) then "OFF" else "ON";

  # Not really sure why I need to do this.. If I call clang-tools without the override it defaults to a different version and fails
  clangTools = clang-tools.override { inherit stdenv llvmPackages; };
  # If boost has python enabled, then boost-python package will be installed which is used by libpulsars python wrapper
  boost = if enablePython then boost17x.override { inherit stdenv enablePython; python = python3; } else boost17x;
in
stdenv.mkDerivation rec {
  pname = "libpulsar";
  version = "2.9.1";

  src = fetchurl {
    sha512 = "sha512-NKHiL7D/Lmnn6ICpQyUmmQYQETz4nZPJU9/4LMRDUQ3Pck6qDh+t6CRk+b9UQ2Vb0jvPIGTjEsSp2nC7TJk3ug==";
    url = "https://archive.apache.org/dist/pulsar/pulsar-${version}/apache-pulsar-${version}-src.tar.gz";
  };

  sourceRoot = "apache-pulsar-${version}-src/pulsar-client-cpp";

  # clang-tools needed for clang-format etc
  # filter out null values so users can override optional values(such as gtest)
  nativeBuildInputs = lib.filter (x: x != null) ([ cmake boost protobuf python3 pkg-config gtest ]
    ++ lib.optional stdenv.isDarwin [ clang clangTools ]
    ++ lib.optional stdenv.isLinux [ gcc clangTools ]);

  # Filter out null vaules so users can override optional values(such as log4cxx)
  buildInputs = lib.filter (x: x != null) ([ boost jsoncpp log4cxx openssl protobuf snappy zstd curl zlib ] ++ lib.optional enablePython [ python3 ]);

  # since we cant expand $out in cmakeFlags
  preConfigure = ''
    export cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_LIBDIR=$out/lib"
  '';

  # Needed for GCC on Linux
  NIX_CFLAGS_COMPILE = [ "-Wno-error=return-type" ];

  cmakeFlags = [
    "-DBUILD_TESTS=${enableCmakeFeature gtest}"
    "-DBUILD_PYTHON_WRAPPER=${enableCmakeFeature enablePython}"
    "-DUSE_LOG4CXX=${enableCmakeFeature log4cxx}"
    "-DClangTools_PATH=${clangTools}/bin"
  ];

  enableParallelBuilding = true;
  doInstallCheck = true;
  installCheckPhase = ''
    echo ${lib.escapeShellArg ''
      #include <pulsar/Client.h>
      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    ''} > test.cc
        ${if stdenv.isDarwin
        then "$CC++ test.cc -L $out/lib -I $out/include -lpulsar -o test"
        else "g++ test.cc -L $out/lib -I $out/include -lpulsar -o test" }
  '';

  meta = with lib; {
    homepage = "https://pulsar.apache.org/docs/en/client-libraries-cpp";
    description = "Apache Pulsar C++ library";

    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.corbanr ];
  };
}
