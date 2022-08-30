{
  stdenv,
  lib,
  fetchurl,
  pkgconfig,
  ncurses,
  glib,
  libmaxminddb,
}:
stdenv.mkDerivation rec {
  version = "1.6.2";
  pname = "goaccess";

  src = fetchurl {
    url = "https://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "0635sw649is5awqbcd7hng05h1pl719r7lvbxvfd1gp21kp54cas";
  };

  configureFlags = [
    "--enable-geoip=mmdb"
    "--enable-utf8"
  ];

  nativeBuildInputs = [pkgconfig];
  buildInputs = [
    libmaxminddb
    ncurses
    glib
  ];

  meta = {
    description = "Real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems";
    homepage = "https://goaccess.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [(import ../../../../maintainers/maintainer-list.nix).craun];
  };
}
