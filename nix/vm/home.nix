{
  config,
  lib,
  pkgs,
  herdr,
  ...
}:

let
  inherit (config.home) homeDirectory;
  herdrPkg = herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;
  herdrIntegrations = [
    "claude"
    "codex"
    "pi"
  ];
in
{
  home = {
    username = "kazuki";
    homeDirectory = "/home/kazuki";

    packages = with pkgs; [
      (callPackage ../packages/apm.nix { })
      bun
      deadnix
      ghq
      go
      mise
      nix-output-monitor
      nixfmt
      rustup
      statix
    ];

    sessionVariables = {
      BUN_INSTALL = "${homeDirectory}/.bun";
      CLAUDE_CODE_PLUGIN_PREFER_HTTPS = "1";
    };

    sessionPath = [
      "${homeDirectory}/.local/bin"
      "${homeDirectory}/.bun/bin"
      "${homeDirectory}/.cargo/bin"
    ];

    file = {
      ".local/bin/git-aicommit" = {
        source = ../../scripts/git-aicommit;
        executable = true;
      };
      ".local/share/git-aicommit/subject-policy.md".source =
        ../../agents/.apm/skills/aicommit/subject-policy.md;

      "AGENTS.md".source = ../../AGENTS.md;
      ".codex/AGENTS.md".source = ../../AGENTS.md;
      ".claude/statusline.sh".source = ../../scripts/claude-statusline.sh;
    };

    # On a fresh machine the agents are installed only after the first switch
    # (make tools), so an integration whose agent is missing is skipped instead
    # of aborting activation.
    activation.herdrIntegrations = lib.hm.dag.entryAfter [ "linkGeneration" ] (
      lib.concatMapStringsSep "\n" (
        name:
        "run ${herdrPkg}/bin/herdr integration install ${name} || warnEcho 'herdr: skipped the ${name} integration'"
      ) herdrIntegrations
    );
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  xdg.configFile = {
    "opencode/AGENTS.md".source = ../../AGENTS.md;
    "opencode/tui.json".source = ../../config/opencode/tui.json;
  };

  programs = {
    gh.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zsh.initContent = builtins.readFile ../../config/zsh/vm.zsh;

    lazygit.settings.customCommands = [
      {
        key = "G";
        context = "files";
        command = "git aicommit";
        description = "AI commit (git aicommit)";
      }
    ];

    neovim = {
      extraPackages = with pkgs; [
        clang-tools
        elmPackages.elm-language-server
        elixir-ls
        nodejs
        typescript-language-server
        nil
        rust-analyzer
        ty
      ];

      # Appended so that <leader> expands to the mapleader set in init.lua.
      initLua = lib.mkAfter (builtins.readFile ../../config/neovim/vm.lua);
    };
  };
}
