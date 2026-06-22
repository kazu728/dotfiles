{ config, lib, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/ghq/github.com/kazu728/dotfiles";
  skillsSrc = ../../agent-skills;
  # 各スキルは agent-skills/<name>/ の 1 ディレクトリ（SKILL.md を含む）
  skillNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir skillsSrc)
  );
  # SKILL.md 同形式を使う対象エージェントの skills ディレクトリ（Gemini 等は後で追記）
  agentSkillDirs = [
    ".claude/skills"
    ".codex/skills"
  ];
  mkLink = dir: name: {
    name = "${dir}/${name}";
    value.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/agent-skills/${name}";
  };
in
{
  home.file = lib.listToAttrs (
    lib.concatMap (dir: map (mkLink dir) skillNames) agentSkillDirs
  );
}
