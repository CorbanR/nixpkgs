{pkgs ? import <nixpkgs> {}, ...}: let
  xmlsec-openssl = pkgs.callPackage ./. {};
in
  pkgs.runCommand "xmlsec-openssl" {
    buildInputs = [xmlsec-openssl];
  } ''
    expected () {
    echo "Test expectation failed: $@"
    exit 1
    }

    xmlsec1 --version | grep "openssl" &> /dev/null || expected "To be built with openssl"
    xmlsec1 --version > $out
  ''
