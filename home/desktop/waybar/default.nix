{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    keylist
    pavucontrol
  ];

  xdg.configFile."keylist/config.yaml".source = ./keybinds.yaml;

  programs.waybar =
    let
      font = config.stylix.fonts.monospace.name;
      font_size = config.stylix.fonts.sizes.terminal;
    in
    {
      enable = true;
      style = ''
        * {
          font-family: "${font}";
          font-size: ${toString font_size}pt;
        }
        ${builtins.readFile ./style.css}
      '';
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 40;
          modules-left = [
            "sway/workspaces"
          ];
          modules-center = [
            "sway/window"
          ];
          modules-right = [
            "tray"
            "custom/keybinds"
            "custom/spacer"
            "battery"
            "memory"
            "cpu"
            "custom/spacer"
            "pulseaudio"
            "custom/vpn"
            "network"
            "custom/spacer"
            "clock"
          ];
          "sway/window" = {
            all-outputs = true;
            offscreen-css = true;
          };
          "sway/workspaces" = {
            format = "{index}{name}";
          };
          "custom/keybinds" = {
            format = "󰌌";
            on-click = "keylist";
            tooltip = false;
          };
          battery = {
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% {icon}󱐋";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            states = {
              critical = 20;
            };
          };
          memory = {
            format = "{used}G ";
            on-click = "alacritty -e btop";
          };
          cpu = {
            format = "{usage}% ";
            on-click = "alacritty -e btop";
          };
          pulseaudio = {
            format = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "pavucontrol";
            on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
            on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            smooth-scrolling-threshold = 1;
          };
          "custom/date" = {
            format = "{}";
            exec = "date '+%d/%m'";
            interval = 60;
          };
          clock = {
            format = "{:%d/%m %H:%M:%S}";
            interval = 1;
            tooltip-format = "<tt>{calendar}</tt>";
            calendar = {
              mode = "month";
              format = {
                today = "<span color='#ff6699'><b>{}</b></span>";
              };
            };
          };
          "custom/spacer" = {
            format = "|";
            tooltip = false;
          };
          tray = {
            icon-size = 18;
            spacing = 5;
          };
          "custom/vpn" = {
            format = "{}";
            exec = builtins.readFile ./mullvad-status.sh;
            return-type = "json";
            interval = 10;
          };
          network = {
            format = "";
            format-disconnected = "󰤮";
            format-ethernet = "󰈀";
            format-wifi = "{icon}";
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            tooltip-format-wifi = "{essid} ({signalStrength}%)"; # wifi name is essid, {frequency} gives freq in GHz
            tooltip-format-ethernet = ''
              {ifname}, {ipaddr}
              <span color='#5FD136'>󰕒 {bandwidthUpBytes}</span> <span color='#D13636'>󰇚 {bandwidthDownBytes}</span>'';
            tooltip-format-disconnected = "<span color='#D13636'>no connection</span>";
          };
        };
      };
    };
}
