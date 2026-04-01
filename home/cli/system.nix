{
  pkgs,
  hostProfile,
  ...
}:
{
  home.packages = with pkgs; [
    procs # ps
    duf # df
    dust # du
    btop # htop
    fastfetch

    nh
    nix-output-monitor
  ];

  programs.fish.shellAliases = {
    ps = "procs";
    df = "duf";
    du = "dust";
    top = "btop";

    rebuild = "nh os switch /etc/nixos --hostname ${hostProfile}";
    nom = "nix-output-monitor";
  };
}
