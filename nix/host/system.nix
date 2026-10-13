{ config, ... }:

{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.zsh.enable = true;

  users.users.kazuki.home = "/Users/kazuki";

  time.timeZone = "Asia/Tokyo";

  system = {
    stateVersion = 7;
    startup.chime = false;
    primaryUser = "kazuki";

    defaults = {
      controlcenter = {
        BatteryShowPercentage = true;
        Bluetooth = true;
        Sound = true;
      };

      finder = {
        FXPreferredViewStyle = "Nlsv";
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
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };

      CustomUserPreferences = {
        "com.apple.assistant.support"."Assistant Enabled" = false;
        "com.apple.HIToolbox".AppleEnabledInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 252;
            "KeyboardLayout Name" = "ABC";
          }
          {
            InputSourceKind = "Input Mode";
            "Bundle ID" = "com.apple.inputmethod.Kotoeri.RomajiTyping";
            "Input Mode" = "com.apple.inputmethod.Japanese";
          }
          {
            InputSourceKind = "Keyboard Input Method";
            "Bundle ID" = "com.apple.inputmethod.Kotoeri.RomajiTyping";
          }
          {
            InputSourceKind = "Non Keyboard Input Method";
            "Bundle ID" = "com.apple.CharacterPaletteIM";
          }
          {
            InputSourceKind = "Non Keyboard Input Method";
            "Bundle ID" = "com.apple.50onPaletteIM";
          }
          {
            InputSourceKind = "Non Keyboard Input Method";
            "Bundle ID" = "com.apple.PressAndHold";
          }
        ];
        "com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
          "28".enabled = false;
          "29".enabled = false;
          "30".enabled = false;
          "31".enabled = false;
          "184".enabled = false;
          "64".enabled = false;
          "65".enabled = false;
        };
        "~${config.system.primaryUser}/Library/Preferences/ByHost/com.apple.screensaver".idleTime = 3600;
      };
    };

    activationScripts.postActivation.text = ''
      pmset -b displaysleep 60
    '';

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  networking = {
    computerName = "mba";
    localHostName = "mba";

    applicationFirewall = {
      enable = true;
      blockAllIncoming = false;
      allowSigned = true;
      allowSignedApp = true;
      enableStealthMode = true;
    };
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation.cleanup = "zap";
    casks = [
      "appcleaner"
      "bitwarden"
      "chatgpt"
      "claude"
      "cleanshot"
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
      "wireshark-app"
      "zoom"
      "zulip"
    ];
    masApps = {
      "Amazon Kindle" = 302584613;
      iMovie = 408981434;
      Keynote = 361285480;
      LINE = 539883307;
      Numbers = 361304891;
      Pages = 361309726;
    };
  };
}
