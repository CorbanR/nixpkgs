{
  pkgs,
  fetchpatch,
  ...
}:
pkgs.mkTerraform {
  version = "0.12.31";
  sha256 = "03p698xdbk5gj0f9v8v1fpd74zng3948dyy4f2hv7zgks9hid7fg";
  patches = [
    ./provider-path.patch
    (fetchpatch {
      name = "fix-mac-mojave-crashes.patch";
      url = "https://github.com/hashicorp/terraform/commit/cd65b28da051174a13ac76e54b7bb95d3051255c.patch";
      sha256 = "1k70kk4hli72x8gza6fy3vpckdm3sf881w61fmssrah3hgmfmbrs";
    })
  ];
  passthru = {};
}
