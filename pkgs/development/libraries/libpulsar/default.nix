{ stdenv
, pkgs
, fetchurl
, version ? "2.6.1"
, sha512 ? "0b09891b0af5cff4856564acaab6d93fdbd5425315b3eb27bc8ff4a519c1e18601f2d93ccc9f0e313ae76d61685422bcc6bea37a47e463e3270f9bba51cc7434"
, boost17x
, clang
, llvmPackages
, cmake
, curl
, gcc
, jsoncpp
, log4cxx
, openssl
, pkgconfig
, protobuf
, python37
, snappy
, zlib
, zstd}:

let
  # Not really sure why I need to do this.. If I call clang-tools without the override it defaults to clang_10
  clang-tools = pkgs.clang-tools.override {inherit stdenv llvmPackages;};
in
  stdenv.mkDerivation rec {
    pname = "libpulsar";
    inherit version;

    src = fetchurl {
      inherit sha512;
      url = "https://archive.apache.org/dist/pulsar/pulsar-${version}/apache-pulsar-${version}-src.tar.gz";
    };

    sourceRoot = "apache-pulsar-${version}/pulsar-client-cpp";

  # python37 used in cmake script to calculate some values
  # clang-tools needed for clang-format etc
  nativeBuildInputs = [ cmake python37 pkgconfig ]
  ++ stdenv.lib.optional stdenv.isDarwin [ clang clang-tools ]
  ++ stdenv.lib.optional stdenv.isLinux [ gcc clang-tools ];

  buildInputs = [ boost17x jsoncpp log4cxx openssl protobuf snappy zstd curl zlib ];

  # since we cant expand $out in cmakeFlags
  preConfigure = ''cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_LIBDIR=$out/lib"'';

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DBUILD_PYTHON_WRAPPER=OFF"
    "-DClangTools_PATH=${clang-tools}/bin"
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
      maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
    };
  }
