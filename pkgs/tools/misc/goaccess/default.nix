{ stdenv, lib, fetchurl, pkgconfig, ncurses, glib, libmaxminddb }:

stdenv.mkDerivation rec {
  version = "1.4";
  pname = "goaccess";

  src = fetchurl {
    url = "https://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "1gkpjg39f3afdwm9128jqjsfap07p8s027czzlnxfmi5hpzvkyz8";
  };

  configureFlags = [
    "--enable-geoip=mmdb"
    "--enable-utf8"
  ];

  # Required for goaccess to build on OSX.
  # Won't be required once goaccess cuts a new release
  prePatch = if stdenv.hostPlatform.isDarwin
  then ''
    substituteInPlace src/parser.c \
      --replace '#include <malloc.h>' ""
  ''
  else null;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libmaxminddb
    ncurses
    glib
  ];

  meta = {
    description = "Real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems";
    homepage    = "https://goaccess.io";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ (import ../../../../maintainers/maintainer-list.nix).craun ];
  };
}
