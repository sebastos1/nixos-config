{
  pkgs,
  nix-gaming,
  ...
}:
{
  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  imports = [
    "${nix-gaming}/modules/pipewireLowLatency.nix"
    "${nix-gaming}/modules/platformOptimizations.nix"
  ];

  # lets apps use the gpu
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    platformOptimizations.enable = true;
    protontricks.enable = true;
    gamescopeSession.enable = false;
    extraPackages = with pkgs; [
      python3 # for elden ring
    ];
  };
}
