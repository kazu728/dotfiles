# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Track the latest stable kernel to improve rtw89_8852be Wi-Fi stability.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;
  # Disable Wi-Fi power saving to reduce link drops.
  networking.networkmanager.wifi.powersave = false;

  hardware.graphics.enable = false;

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Firewall: expose k3s API only via tailscale; trust pod networks.
  networking.firewall = {
    enable = true;
    interfaces.tailscale0.allowedTCPPorts = [ 6443 32443 30300 ];
    trustedInterfaces = [ "cni0" "flannel.1" ];
  };

  # Use compressed RAM swap to soften OOMs without disk swap.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };

  services.logind.extraConfig = ''
  HandleSuspendKey=ignore
  HandleHibernateKey=ignore
  HandleLidSwitch=ignore
  IdleAction=ignore
  '';

  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = false;
    settings.PubkeyAuthentication = true;
  };
  

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.kazuki = {
    isNormalUser = true;
    description = "Kazuki Matsuo";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    kubectl
    kubernetes-helm
    kubeseal
  ];
  # Make kubectl point to k3s kubeconfig by default.
  environment.sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

  # Lightweight single-node k3s
  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = true;
    extraFlags = "--write-kubeconfig-mode=644 --disable traefik --disable servicelb --kubelet-arg=max-pods=50";
  };

  systemd.services.k3s-manifests = {
    description = "Link k3s bootstrap manifests from /etc/nixos";
    before = [ "k3s.service" ];
    wantedBy = [ "k3s.service" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      set -euo pipefail

      src=/etc/nixos/k3s/manifests
      dst=/var/lib/rancher/k3s/server/manifests

      ${pkgs.coreutils}/bin/install -d -m 0755 "$dst"
      if [ -d "$src" ]; then
        for f in "$src"/*.yaml; do
          [ -e "$f" ] || continue
          ${pkgs.coreutils}/bin/ln -sf "$f" "$dst/$(basename "$f")"
        done
      fi
      for link in "$dst"/*.yaml; do
        if [ -L "$link" ] && [ ! -e "$link" ]; then
          ${pkgs.coreutils}/bin/rm -f "$link"
        fi
      done
    '';
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # ============================================================
  # GUI Recovery Configuration (for emergency use)
  # 画面復旧用設定（緊急時のみ使用）
  # ============================================================
  services.xserver.enable = false;
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  services.libinput.enable = true;
  services.xserver.xkb = {
    layout = "jp";
    variant = "";
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
