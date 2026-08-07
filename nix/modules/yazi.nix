{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      mgr = {
        show_hidden = true;
        ratio = [
          0
          1
          2
        ];
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
        }
        {
          on = "M";
          run = "shell --block -- mdpx %h";
        }
      ];
    };
  };
}
