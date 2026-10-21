{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  sources = {
    aarch64-darwin = {
      asset = "apm-darwin-arm64.tar.gz";
      hash = "sha256-Aws4GCV5kzOsYKNpqvAh/8n56SVYs3X+7GVsQuUOjlo=";
    };
    aarch64-linux = {
      asset = "apm-linux-arm64.tar.gz";
      hash = "sha256-vzVUScu3S5YOOm6+hRo17Cwd9vUXj7s2uQxaOgFdLCo=";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation rec {
  pname = "apm";
  version = "0.34.0";

  src = fetchurl {
    url = "https://github.com/microsoft/apm/releases/download/v${version}/${source.asset}";
    inherit (source) hash;
  };

  dontFixup = true;

  installPhase = ''
    mkdir -p $out/lib/apm $out/bin
    cp -R . $out/lib/apm/
    ln -s $out/lib/apm/apm $out/bin/apm
  '';

  meta = {
    description = "Agent Package Manager";
    homepage = "https://github.com/microsoft/apm";
    license = lib.licenses.mit;
    mainProgram = "apm";
    platforms = builtins.attrNames sources;
  };
}
