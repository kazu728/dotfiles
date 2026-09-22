{ docker-sbx, fetchurl }:

let
  version = "0.43.0";
in
docker-sbx.overrideAttrs {
  inherit version;

  src = fetchurl {
    url = "https://github.com/docker/sbx-releases/releases/download/v${version}/DockerSandboxes-darwin.tar.gz";
    hash = "sha256-6fybO66cVyilcm9JubNgkyhRnaV288mf2Ofl0TcAinw=";
  };
}
