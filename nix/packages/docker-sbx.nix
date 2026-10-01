{ docker-sbx, fetchurl }:

let
  version = "0.46.0";
in
docker-sbx.overrideAttrs {
  inherit version;

  # Running the binary marks Sbx.app with com.apple.macl, which SIP then
  # refuses to let Nix canonicalise the store path.
  doInstallCheck = false;

  src = fetchurl {
    url = "https://github.com/docker/sbx-releases/releases/download/v${version}/DockerSandboxes-darwin.tar.gz";
    hash = "sha256-HaoHenk7wEjvaayzPLidJ84Glu+t9E32RmRj8qeditw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R Sbx.app bin $out/

    installShellCompletion \
      --bash --name sbx.bash Sbx.app/Contents/Resources/completions/bash/sbx \
      --zsh  --name _sbx     Sbx.app/Contents/Resources/completions/zsh/_sbx \
      --fish --name sbx.fish Sbx.app/Contents/Resources/completions/fish/sbx.fish

    runHook postInstall
  '';
}
