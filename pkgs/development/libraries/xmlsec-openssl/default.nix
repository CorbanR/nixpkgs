{ pkgs, ...}:

let
  # Additional config flags to appease
  # https://github.com/instructure/nokogiri-xmlsec-instructure/blob/master/ext/nokogiri_ext_xmlsec/init.c
  xmlsecConfigFlags = [ "--disable-dependency-tracking"
  "--disable-crypto-dl" "--disable-apps-crypto-dl" "--with-openssl"
];

in
  pkgs.xmlsec.overrideAttrs (oldAttrs: rec {
    version = "1.2.28";
    sha256 = "1m12caglhyx08g8lh2sl3nkldlpryzdx2d572q73y3m33s0w9vhk";
    configureFlags = xmlsecConfigFlags;
  })
