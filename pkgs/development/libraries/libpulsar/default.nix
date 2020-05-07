{ stdenv, fetchurl
, version ? "2.5.1"
, sha256 ? "0dgh8w039l99is79pqk428q44yy65q1f1rn6v5spgns9qm7p8sg2"
, boost17x
, clang-tools
, clangStdenv
, clang_10
, cmake
, curl
, gcc
, jsoncpp
, llvmPackages_10
, log4cxx
, openssl
, overrideCC
, pkgconfig
, protobuf
, python37
, snappy
, zlib
, zstd}:

let
  sources = import ./sources.nix {
    inherit fetchurl version sha256;
  };

  buildStdenv = if stdenv.isDarwin then
    overrideCC clangStdenv [ clang_10 llvmPackages_10.llvm llvmPackages_10.lld ]
    else
    stdenv;

in buildStdenv.mkDerivation rec {
  pname = "libpulsar";
  inherit version;

  src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");
  sourceRoot = "apache-pulsar-${version}/pulsar-client-cpp";

  # python37 used in cmake script to calculate some values
  # clang-tools needed for clang-format etc
  nativeBuildInputs = [ cmake python37 pkgconfig ]
    ++ stdenv.lib.optional stdenv.isDarwin [ clang_10 clang-tools ]
    ++ stdenv.lib.optional stdenv.isLinux [ gcc clang-tools ];

  buildInputs = [ boost17x jsoncpp log4cxx openssl protobuf snappy zstd curl zlib ];

  # since we cant expand $out in cmakeFlags
  preConfigure = ''cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_LIBDIR=$out/lib"'';

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DBUILD_PYTHON_WRAPPER=OFF"
    "-DClangTools_PATH=${clang-tools}/bin"
    "-DUSE_LOG4CXX=ON"
    #"-DBoost_INCLUDE_DIRS=${boost17x}/include"
    #"-DLINK_STATIC=ON"
    #"-DProtobuf_INCLUDE_DIR=${protobuf}/include"
    #"-DProtobuf_LIBRARIES=${protobuf}/lib/libprotobuf.dylib"
  ];

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckPhase = ''
    echo ${stdenv.lib.escapeShellArg ''
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

  meta = with stdenv.lib; {
    homepage = "https://pulsar.apache.org/docs/en/client-libraries-cpp";
    description = "Apache Pulsar C++ library";

    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    license = licenses.asl20;
    maintainers = with maintainers; [ craun ];
  };
}
