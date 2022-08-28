{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.vim ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  programs.zsh.enable = true;

  system.stateVersion = 4;

  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = true;
      _FXShowPosixPathInTitle = true;
    };

    dock = {
      autohide = true;
      autohide-delay = "0.0";
    };
     NSGlobalDomain = {
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.sound.beep.volume" = "0.000";
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.scaling" = "1.75";
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
      AppleShowAllExtensions = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  homebrew = {
    enable = true;
  };
}