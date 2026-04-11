{
  pkgs,
  hostProfile,
  ...
}:
{
  home.packages = with pkgs; [
    nh
    nix-output-monitor

    procs # ps
    duf # df
    dust # du
    btop # htop
    fastfetch
  ];

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  programs.fish.shellAliases = {
    ps = "procs";
    df = "duf";
    du = "dust";
    top = "btop";

    rebuild = "nh os switch --hostname ${hostProfile}";
    nom = "nix-output-monitor";
  };
}
