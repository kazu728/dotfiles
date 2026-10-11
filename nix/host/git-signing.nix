{ config, lib, ... }:

let
  inherit (config.programs.git.settings.user) email;

  # Secretive holds this one without a per-use authentication requirement, so
  # commits don't prompt. The key used to authenticate pushes still requires it.
  signingKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNMFEKr5t+q4S+knKxhNyQoHchKfo08F7Ct0esXSws9AC4l1/7cSlZF616x1B8TxTtjsKHS2c2zEfg3P8djmkvs= github_signing@secretive.mba.local";

  # Only verifies commits signed before signing and authentication were split.
  retiredSigningKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHxrSOVyERLr5n6WAxcHo8lKeiVR4ai2bqbC68lR/Vt8MEv2JKmvZQh6aoO9eSbs6m3vG3czdB1Dn6nQkErOcRA= github@secretive.mba.local";
in
{
  xdg.configFile."git/allowed_signers".text = lib.concatMapStrings (key: "${email} ${key}\n") [
    signingKey
    retiredSigningKey
  ];

  programs.git.settings = {
    commit.gpgsign = true;
    gpg.format = "ssh";
    gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
    tag.gpgsign = true;
    user.signingKey = "key::${signingKey}";
  };
}
