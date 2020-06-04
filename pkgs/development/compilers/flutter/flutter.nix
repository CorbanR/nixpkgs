{bash
,cacert
,coreutils
,curl
,git
,makeWrapper
,which
,channel
,pname
,version
,sha256Hash
,filename
,stdenv
,fetchurl
,unzip }:

let
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;

  source = fetchurl {
    url = "https://storage.googleapis.com/flutter_infra/releases/${channel}/macos/${filename}";
    sha256 = sha256Hash;
  };

in

with stdenv.lib;

stdenv.mkDerivation {

  pname = "flutter-${channel}";
  inherit version;

  buildInputs = [ bash cacert coreutils curl git makeWrapper unzip which ];

  nativeBuildInputs = [ makeWrapper ];

  patches = getPatches (./patches + "/${channel}");

  src = source;

  buildPhase = ''
    FLUTTER_ROOT=$(pwd)
    FLUTTER_TOOLS_DIR="$FLUTTER_ROOT/packages/flutter_tools"
    SNAPSHOT_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot"
    STAMP_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.stamp"
    SCRIPT_PATH="$FLUTTER_TOOLS_DIR/bin/flutter_tools.dart"
    DART_SDK_PATH="$FLUTTER_ROOT/bin/cache/dart-sdk"
    DART="$DART_SDK_PATH/bin/dart"
    PUB="$DART_SDK_PATH/bin/pub"
    HOME=../.. # required for pub upgrade --offline, ~/.pub-cache
               # path is relative otherwise it's replaced by /build/flutter
    (cd "$FLUTTER_TOOLS_DIR" && "$PUB" upgrade --offline)
    local revision="$(cd "$FLUTTER_ROOT"; git rev-parse HEAD)"
    "$DART" --snapshot="$SNAPSHOT_PATH" --packages="$FLUTTER_TOOLS_DIR/.packages" "$SCRIPT_PATH"
    echo "$revision" > "$STAMP_PATH"
    echo -n "${version}" > version
    rm -rf bin/cache/{artifacts,downloads}
    rm -f  bin/cache/*.stamp
  '';

  installPhase = ''
    mkdir -p $out
    cp -r . $out/
  '';

  #postInstall = ''
    #wrapProgram $out/bin/flutter \
    #--set PUB_CACHE ''${PUB_CACHE:-"$HOME/.pub-cache"} \
    #--set ANDROID_EMULATOR_USE_SYSTEM_LIBS 1 \
    #--add-flags --no-version-check
    #'';

  dontStrip = true;

  #doInstallCheck = false;
  #installCheckPhase = ''
    #echo ${stdenv.lib.escapeShellArg ''
      #void main() {
        #print('Hello, World!');
      #}
      #''} > main.dart
    #$out/bin/dart main.dart

    #$out/bin/dart2native main.dart -o hello
    #./hello
  #'';

  meta = {
    homepage = "https://flutter.dev";
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
    description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
    longDescription = ''
      Flutter is Google’s UI toolkit for building beautiful,
      natively compiled applications for mobile, web, and desktop from a single codebase.
    '';
    platforms = [ "x86_64-darwin" ];
    license = licenses.bsd3;
  };
}
