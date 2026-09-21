{ docker-sbx, fetchurl }:

docker-sbx.overrideAttrs (finalAttrs: {
  version = "0.43.0";

  src = fetchurl {
    url = "https://github.com/docker/sbx-releases/releases/download/v${finalAttrs.version}/DockerSandboxes-darwin.tar.gz";
    hash = "sha256-6fybO66cVyilcm9JubNgkyhRnaV288mf2Ofl0TcAinw=";
  };
})
