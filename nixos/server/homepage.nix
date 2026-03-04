{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.whoami = {
    image = "traefik/whoami";
    ports = ["8889:80"];
    labels = {
      "homepage.group" = "Apps";
      "homepage.name" = "whoami";
      "homepage.href" = "http://localhost:8889";
      "homepage.description" = "Who are you?";
    };
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = 3002;
    docker.my-podman.socket = "/run/podman/podman.sock";

    widgets = [
      {
        resources = {
          uptime = true;
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
    ];

    services = [
      {
        "System" = [
          {
            "CPU" = {
              widget = {
                type = "glances";
                url = "http://localhost:61208";
                version = 4;
                metric = "cpu";
              };
            };
          }
          {
            "Memory" = {
              widget = {
                type = "glances";
                url = "http://localhost:61208";
                version = 4;
                metric = "memory";
              };
            };
          }
          {
            "Network" = {
              widget = {
                type = "glances";
                url = "http://localhost:61208";
                version = 4;
                metric = "network:enp4s0";
              };
            };
          }
          {
            "Process" = {
              widget = {
                type = "glances";
                url = "http://localhost:61208";
                version = 4;
                metric = "process";
              };
            };
          }
        ];
      }
    ];
  };

  systemd.services.homepage-dashboard.serviceConfig.SupplementaryGroups = [ "podman" ];

  services.glances = {
    enable = true;
    openFirewall = false;
    port = 61208;
  };
}
