{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      mgr = {
        ratio = [ 0 1 2 ];
      };
    };
    plugins = {
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "プレビューを最大化/元に戻す";
        }
      ];
    };
  };
}
