{pkgs, ...}: let
  # Additional config flags to appease
  # https://github.com/instructure/nokogiri-xmlsec-instructure/blob/master/ext/nokogiri_ext_xmlsec/init.c
  xmlsecConfigFlags = [
    "--disable-dependency-tracking"
    "--disable-crypto-dl"
    "--disable-apps-crypto-dl"
    "--with-openssl"
  ];
in
  pkgs.xmlsec.overrideAttrs (oldAttrs: rec {
    version = "1.2.31";
    sha256 = "mxC8Uswx5PdhYuOXXlDbJrcatJxXHYELMRymJr5aCyY=";
    configureFlags = oldAttrs.configureFlags ++ xmlsecConfigFlags;
  })
