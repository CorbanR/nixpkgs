{ stdenv, fetchurl, setJavaClassPath, zlib
, javaVersion ? "11"
, graalvmVersion ? "20.2.0" }:

let
  sources = import ./sources-ce-bin.nix {
    inherit fetchurl javaVersion graalvmVersion;
  };

  system_src = sources.${stdenv.hostPlatform.system}.${javaVersion} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

in stdenv.mkDerivation {
  name = "graalvm-ce-java${javaVersion}";

  src = system_src.graalvm;

  sourceRoot = ".";

  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    ${if stdenv.isDarwin
    then "mv graalvm*/Contents/Home/* $out"
    else "mv graalvm*/* $out"}

    $out/bin/gu -L install ${system_src.native-image}
    $out/bin/gu -L install ${system_src.llvm-toolchain}
    $out/bin/gu -L install ${system_src.wasm}
  '';

  propagatedBuildInputs = [ setJavaClassPath zlib];

  preFixup = ''
      # Propagate the setJavaClassPath setup hook from the JDK so that
      # any package that depends on the JDK has $CLASSPATH set up
      # properly.
      mkdir -p $out/nix-support
      printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

      # Set JAVA_HOME automatically.
      cat <<EOF >> $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

  doInstallCheck = true;
  installCheckPhase = ''
    echo ${stdenv.lib.escapeShellArg ''
             public class HelloWorld {
               public static void main(String[] args) {
                 System.out.println("Hello World");
               }
             }
           ''} > HelloWorld.java
    $out/bin/javac HelloWorld.java
    # run on JVM with Graal Compiler
    $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld
    $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld | fgrep 'Hello World'
    # Ahead-Of-Time compilation
    #
    #$out/bin/native-image -H:+ReportExceptionStackTraces --verbose --no-server HelloWorld
    #./helloworld
    #./helloworld | fgrep 'Hello World'
    ${stdenv.lib.optionalString stdenv.isLinux
      ''
        # Ahead-Of-Time compilation with --static
        $out/bin/native-image --no-server --static HelloWorld
        ./helloworld
        ./helloworld | fgrep 'Hello World'
      ''}
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.graalvm.org/";
    description = "High-performance polyglot VM";
    # Darwin only for now as linux is more of a pain
    platforms = [ "x86_64-darwin" ];
    license = licenses.gpl2;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
