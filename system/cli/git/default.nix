{
  config,
  pkgs,
  username,
  ...
}:

{
  hjem.users.${username}.files = {
    ".config/git/config".source = ./gitconfig;
    ".config/lazygit/config.yml".source = ./lazygit.yml;
  };

  users.users.${username}.packages = with pkgs; [
    git
    delta
    lazygit
  ];
}
