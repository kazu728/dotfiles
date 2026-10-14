{ config, pkgs, ... }:

let
  inherit (config.home) homeDirectory;
in
{
  home = {
    packages = [
      (pkgs.callPackage ../packages/apm.nix { })
      # pi runs on whichever node is on PATH.
      pkgs.nodejs
    ];

    sessionVariables.CLAUDE_CODE_PLUGIN_PREFER_HTTPS = "1";

    sessionPath = [
      "${homeDirectory}/.local/bin"
      "${homeDirectory}/.opencode/bin"
    ];

    file = {
      "AGENTS.md".source = ../../AGENTS.md;
      ".codex/AGENTS.md".source = ../../AGENTS.md;
      ".claude/statusline.sh".source = ../../scripts/claude-statusline.sh;

      ".local/bin/git-aicommit" = {
        source = ../../scripts/git-aicommit;
        executable = true;
      };
      ".local/share/git-aicommit/subject-policy.md".source =
        ../../agents/.apm/skills/aicommit/subject-policy.md;
    };
  };

  xdg.configFile = {
    "opencode/AGENTS.md".source = ../../AGENTS.md;
    "opencode/tui.json".source = ../../config/opencode/tui.json;
  };

  programs = {
    zsh.initContent = builtins.readFile ../../config/zsh/agents.zsh;

    lazygit.settings.customCommands = [
      {
        key = "G";
        context = "files";
        command = "git aicommit";
        description = "AI commit (git aicommit)";
      }
    ];
  };
}
