{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
in
{
  networking = {
    hostName = secrets.hostname;
    useDHCP = true;
    interfaces = {
      wlan0.useDHCP = true;
    };
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      networks = secrets.wireless_networks;
    };
    # Tailscale経由で接続するためingress通信は何も許可しない
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  environment.systemPackages = with pkgs; [ 
    docker
    git
    k3s
    vim
    libcgroup
  ];

  systemd.services.k3s = {
    enable = true;
    description = "Lightweight Kubernetes (K3s)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.k3s}/bin/k3s server --write-kubeconfig-mode 644";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  services.tailscale.enable = true;

  services = {
    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        MaxAuthTries = 3;
        LoginGraceTime = "30s";
      };
      extraConfig = ''
        AllowUsers ${secrets.user_name}
        ClientAliveInterval 300
        ClientAliveCountMax 2
      '';
    };
  };

  programs.nix-ld.enable = true;

  users = {
    mutableUsers = false;
    users.${secrets.user_name} = {
      isNormalUser = true;
      password = secrets.user_password;
      extraGroups = [ "wheel" "docker" "systemd-journal" ];
      openssh.authorizedKeys.keyFiles = [ ../ssh/authorized_keys ];
    };
  };

  virtualisation.docker.enable = true;

  security.sudo = {
    wheelNeedsPassword = true;
    extraRules = [
      {
        users = [ "${secrets.user_name}" ];
        commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
      }
    ];
  };

  system.stateVersion = "23.11";
}