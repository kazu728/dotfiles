{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ (pkgs.callPackage ./packages/apm.nix { }) ];

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.zsh.enable = true;

  users.users.kazuki.home = "/Users/kazuki";

  system = {
    stateVersion = 4;
    startup.chime = false;
    primaryUser = "kazuki";

    defaults = {
      finder = {
        FXRemoveOldTrashItems = true;
        _FXShowPosixPathInTitle = true;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        show-recents = false;
      };
      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.000;
        "com.apple.trackpad.scaling" = 3.0;
        "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        AppleShowAllExtensions = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  networking.applicationFirewall = {
    enable = true;
    blockAllIncoming = false;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation.cleanup = "zap";
    brews = [
      "automake"
      "awscli"
      "coreutils"
      "cryptography"
      "direnv"
      "expect"
      "just"
      "libgit2"
      "libyaml"
      "mise"
      "poppler"
      "sevenzip"
      "shellcheck"
      "unixodbc"
      "unzip"
      "wxwidgets"
    ];
    casks = [
      "appcleaner"
      "bitwarden"
      "discord"
      "ghostty"
      "google-chrome"
      "google-chrome@canary"
      "google-drive"
      "karabiner-elements"
      "keycastr"
      "orbstack"
      "raycast"
      "secretive"
      "slack"
      "spotify"
      "tailscale-app"
      "twingate"
      "utm"
      "wireshark-app"
      "wkhtmltopdf"
      "zulip"
    ];
  };
}
