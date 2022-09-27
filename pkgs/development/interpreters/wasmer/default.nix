{ cmake
, fetchFromGitHub
, gcc12
, gnumake
, lib
, libffi
, libiconv
, libintl
, libtool
, libxml2
, libxslt
, llvmPackages_12
, ncurses
, pkg-config
, rustPlatform
, stdenv
, xz
, zlib
}:

let
  aarchX86Inputs = [ libffi xz zlib libintl ncurses libxml2 ];
  aarchX86Native = [ ncurses xz zlib libffi libintl gnumake libtool libxml2 libxslt libiconv llvmPackages_12.clangUseLLVM ];
  sharedNative = [ cmake pkg-config gcc12 llvmPackages_12.llvm ];
in

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = version;
    sha256 = "sha256-25wWgMNybbsEf/1xmm+8BPcjx8CSW9ZBzxGKT/DbBXw=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-tswsbijNN5UcSZovVmy66yehcEOpQDGMdRgR/1mkuE8=";

  # See https://github.com/wasmerio/wasmer/blob/2.3.0/Makefile#L20

  nativeBuildInputs = [] ++ sharedNative ++ lib.optionals(stdenv.isx86_64) aarchX86Native;
  buildInputs = [] ++ lib.optionals(stdenv.isx86_64) aarchX86Inputs;

  # cranelift+jit works everywhere, see:
  # https://github.com/wasmerio/wasmer/blob/2.3.0/Makefile#L20
  buildFeatures = [ "cranelift" "jit" ]
    # Cannot get "llvm" to work on darwin :( `ld: symbol(s) not found for architecture ARCH`
    ++ lib.optionals(stdenv.isx86_64) ["singlepass"]
    ++ lib.optionals(stdenv.isx86_64 && stdenv.isLinux) ["llvm"];

  cargoBuildFlags = [
    # must target manifest and desired output bin, otherwise output is empty
    "--manifest-path" "lib/cli/Cargo.toml"
    "--bin" "wasmer"
  ];

  # Patch that removes unreachable.wast test
  patches = [./patches/tests.patch];

  # Can't use test-jit:
  # error: Package `wasmer-workspace v2.3.0 (/build/source)` does not have the feature `test-jit`
  checkPhase = ''
   ${gnumake}/bin/make test-cranelift-universal

   ${lib.optionalString (stdenv.isx86_64)
   "${gnumake}/bin/make test-cranelift"}

   ${lib.optionalString (stdenv.isx86_64 && stdenv.isLinux)
   "${gnumake}/bin/make test-llvm"}
  '' ;

  LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";

  meta = with lib; {
    description = "The Universal WebAssembly Runtime";
    longDescription = ''
      Wasmer is a standalone WebAssembly runtime for running WebAssembly outside
      of the browser, supporting WASI and Emscripten. Wasmer can be used
      standalone (via the CLI) and embedded in different languages, running in
      x86 and ARM devices.
    '';
    homepage = "https://wasmer.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne shamilton ];
  };
}
