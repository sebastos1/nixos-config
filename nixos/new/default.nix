{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-config.nix
  ];

  # services.mullvad-vpn.enable = true;
  networking.hostName = "new";

  # wayland (sway)
#   security.polkit.enable = true;
#   services.greetd = {
#     enable = true;
#     settings = rec {
#       initial_session = {
#         command = "${pkgs.swayfx}/bin/sway --unsupported-gpu";
#         user = "seb";
#       };
#       default_session = initial_session;
#     };
#   };
}