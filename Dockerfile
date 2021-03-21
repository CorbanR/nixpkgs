FROM ubuntu:focal

ARG NIX_VERSION=2.3.10

RUN apt-get update && apt-get install -qqy curl vim-tiny xz-utils \
      tar gzip ca-certificates sudo --no-install-recommends \
      && update-ca-certificates \
      && apt-get clean autoremove -qqy \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

RUN groupadd --gid 30000 nixbld --system \
      && for i in $(seq 1 30); do useradd --system --shell /sbin/nologin --no-user-group --password "!" --home-dir /var/empty --comment "Nix build user $i" --uid $((30000 + i)) --gid 30000 --groups nixbld nixbld$i; done \
      && mkdir -m 0755 /etc/nix \
      && echo 'sandbox = false' > /etc/nix/nix.conf \
      && curl https://nixos.org/releases/nix/nix-${NIX_VERSION}/install --output install \
      && bash install \
      && ln -s /nix/var/nix/profiles/default/etc/profile.d/nix.sh /etc/profile.d/ \
      && rm -r /tmp/* /var/tmp/ install || true \
      && /nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-old \
      && /nix/var/nix/profiles/default/bin/nix-store --optimise \
      && /nix/var/nix/profiles/default/bin/nix-store --verify --check-contents

ONBUILD ENV \
    ENV=/etc/profile \
    USER=root \
    PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
    NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

ENV \
    ENV=/etc/profile \
    USER=root \
    PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
    NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    NIX_PATH=/nix/var/nix/profiles/per-user/root/channels
