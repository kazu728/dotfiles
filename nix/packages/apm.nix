{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  sources = {
    aarch64-darwin = {
      asset = "apm-darwin-arm64.tar.gz";
      hash = "sha256-IuMO89nuSV15j0Z70wYn3LLxemSmDs/KoVymzqojjFY=";
    };
    aarch64-linux = {
      asset = "apm-linux-arm64.tar.gz";
      hash = "sha256-2ZTtSduiwy7jO93MH9lWtvMrV2tRqqOUjdqUYwpYXLg=";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation rec {
  pname = "apm";
  version = "0.32.0";

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
