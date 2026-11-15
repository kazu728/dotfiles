{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  sources = {
    aarch64-darwin = {
      asset = "darwin-arm64";
      hash = "sha256-8gXqXbvaZxZeCKqx+2OVKQymLwoDi/J9S2hKvQgWY1w=";
    };
    aarch64-linux = {
      asset = "linux-arm64";
      hash = "sha256-ruYcmT2jal8Jvix35uShoiVCobMN7UmWv4MBwV3PKzk=";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation rec {
  pname = "gh-actions-lock";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/github/gh-actions-lock/releases/download/v${version}/${source.asset}";
    inherit (source) hash;
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/gh-actions-lock
  '';

  meta = {
    description = "Lock and verify GitHub Actions dependencies";
    homepage = "https://github.com/github/gh-actions-lock";
    license = lib.licenses.mit;
    platforms = builtins.attrNames sources;
  };
}
