{ config, lib, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/ghq/github.com/kazu728/dotfiles";
  skillsRoot = ../../agent-skills;
  dirsIn =
    path: builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir path));
  categories = dirsIn skillsRoot;
  skillsIn = category: dirsIn (skillsRoot + "/${category}");
  agentSkillDirs = [
    ".claude/skills"
    ".codex/skills"
  ];
  mkLink = category: name: agentDir: {
    name = "${agentDir}/${name}";
    value.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/agent-skills/${category}/${name}";
  };
in
{
  home.file = lib.listToAttrs (
    lib.concatMap (
      category: lib.concatMap (name: map (mkLink category name) agentSkillDirs) (skillsIn category)
    ) categories
  );
}
