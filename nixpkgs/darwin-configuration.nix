_:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  programs.zsh.enable = true;

  system = {
    stateVersion = 4;
    startup.chime = false;
    primaryUser = "kazuki";

    defaults = {
      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = true;
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
        "com.apple.trackpad.enableSecondaryClick" = true;
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

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = true;
    };
    taps = [
      "k1LoW/tap"
    ];
    brews = [
      "automake"
      "awscli"
      "coreutils"
      "cryptography"
      "direnv"
      "expect"
      "just"
      "k1LoW/tap/mo"
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
      "android-studio"
      "appcleaner"
      "cloudflare-warp"
      "discord"
      "ghostty"
      "google-chrome"
      "google-chrome@canary"
      "google-drive"
      "iterm2"
      "karabiner-elements"
      "keycastr"
      "orbstack"
      "raycast"
      "secretive"
      "slack"
      "spotify"
      "tableplus"
      "tailscale-app"
      "twingate"
      "utm"
      "wireshark-app"
      "wkhtmltopdf"
      "zulip"
    ];
  };
}
