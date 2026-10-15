_:

{
  home = {
    username = "kazuki";
    homeDirectory = "/home/kazuki";
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
}
