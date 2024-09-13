{ pkgs, ... }:

let
  secrets = import ./secrets.nix;

  user = secrets.user_name;
  password = secrets.user_password;
  hostname = secrets.hostname;
  networks = secrets.wireless_networks;

in {

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    kernelParams = [ "cgroup_enable=cpuset" "cgroup_enable=memory" "cgroup_memory=1" ];
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };
  
  # SDカードの書き込み回数を減らすため、swapをzramにする
  swapDevices = [];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  networking = {
    hostName = hostname;
    useDHCP = true;
    interfaces = {
      wlan0 = {
        useDHCP = true;
      };
    };
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      networks = networks;
    };
  };

  environment.systemPackages = with pkgs; [ 
    docker
    git
    k3s
    vim
    libcgroup
  ];

  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  
  services.tailscale.enable = true;

  # Tailscaleで接続するため、インターネットからの接続は全て拒否する
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHNDMcODa6D7FfipS30eX+NmFi/c6Q6UsPKx5udV3N8Gso6V8WPJb9iK5fwD6KJkPSBWMXMN1AzfOos2cC7B7Pdzo75tDtvLuM2vQmS0UhX5EvJqKbPUqPPR66RPePLcsve7ikEt7+7c4havMl2EVZXaf7zSCORDKdJq130fjL/ZlNvMYHE4rWvtt+Tbx/sch9YlWhETieguhwC3ZW2sJtB1RsNALw6BIXit1okp4MVlPBzIhNzGVuTGws4rxnjEp1L2tq/JU3NFtGIifPQU/e4pqTiFmdP/7uv/hDFPI+4zQTfFKZdDL9YGacc0ruUjIZshupPoCzmMUELlzqTCm7 kazuki@mbp"
      ];
    };
  };

  virtualisation.docker.enable = true;

  security.sudo.wheelNeedsPassword = true;
  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
