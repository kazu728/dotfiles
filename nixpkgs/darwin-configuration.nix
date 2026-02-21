{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.vim ];

  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  system.stateVersion = 4;
  system.startup.chime = false;
  system.primaryUser = "kazuki";

  system.defaults = {
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

  networking.applicationFirewall = {
    enable = true;
    blockAllIncoming = false;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;
  };
}
