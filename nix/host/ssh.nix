{ config, ... }:

let
  secretiveAgent = "${config.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
in
{
  home.sessionVariables.SSH_AUTH_SOCK = secretiveAgent;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    includes = [ "~/.orbstack/ssh/config" ];

    settings = {
      # IdentityFile is left unset, and with it IdentitiesOnly: Secretive keeps
      # its public keys behind Full Disk Access.
      "github github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityAgent = secretiveAgent;
      };

      n150 = {
        HostName = "nixos";
        User = "kazuki";
        IdentityAgent = secretiveAgent;
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%r@%h:%p";
        ControlPersist = 60;
      };
    };
  };
}
