{ config, lib, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/ghq/github.com/kazu728/dotfiles";
  skillsRoot = ../../agent-skills;
  dirsIn =
    path: builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir path));
  agentSkillDirs = [
    ".claude/skills"
    ".codex/skills"
    ".agents/skills"
  ];
  dotfilesSkills = lib.concatMap (
    category:
    map (name: {
      inherit name;
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/agent-skills/${category}/${name}";
    }) (dirsIn (skillsRoot + "/${category}"))
  ) (dirsIn skillsRoot);
  packagedSkills = [
    {
      name = "hunk-review";
      source = "${config.programs.hunk.package}/skills/hunk-review";
    }
  ];
  mkLink = skill: agentDir: lib.nameValuePair "${agentDir}/${skill.name}" { inherit (skill) source; };
in
{
  home.file = lib.listToAttrs (
    lib.concatMap (skill: map (mkLink skill) agentSkillDirs) (dotfilesSkills ++ packagedSkills)
  );
}
