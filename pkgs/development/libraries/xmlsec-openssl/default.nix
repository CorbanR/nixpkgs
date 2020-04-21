{ pkgs, ...}:

let
  # Additional config flags to appease
  # https://github.com/instructure/nokogiri-xmlsec-instructure/blob/master/ext/nokogiri_ext_xmlsec/init.c
  xmlsecConfigFlags = [ "--disable-dependency-tracking"
  "--disable-crypto-dl" "--disable-apps-crypto-dl" "--with-openssl"
];

in
  pkgs.xmlsec.overrideAttrs (oldAttrs: rec {
    configureFlags = xmlsecConfigFlags;
  })
