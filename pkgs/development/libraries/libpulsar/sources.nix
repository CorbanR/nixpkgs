{ fetchurl
, version ? "2.5.1"
, sha256 ? "0dgh8w039l99is79pqk428q44yy65q1f1rn6v5spgns9qm7p8sg2"}:

let
  url = "https://archive.apache.org/dist/pulsar/pulsar-${version}/apache-pulsar-${version}-src.tar.gz";
in
  {
    x86_64-linux = fetchurl {
      inherit url sha256;
    };

    x86_64-darwin = fetchurl {
      inherit url sha256;
    };
  }
