let
  userKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINn2HFhSKi5iytR7UuY8H3I2vZ38I8VtmX7eY+kPmLRP";

  desk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEActGcGJ/zP2Vy1gYmCw+ZRR6l8ciBh/fAbBgecOkC";
  lap = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALJ6Qqyv9CAG+iSPkaYTUosRWPTm4TM2TsREfrdpUyN";
  homeserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENm6wsyUxzEYosjTXs/pwcsWQs2zhV6+dJ6JFb77Zgu";

  allSystems = [
    desk
    lap
    homeserver
  ];
in
{
  # shared
  "secrets/test.age".publicKeys = [ userKey ] ++ allSystems;

  # cloudflare
  "secrets/cf-tunnel-json.age".publicKeys = [
    homeserver
  ];
  "secrets/cf-api-shlb.age".publicKeys = [
    homeserver
  ];

  "example.age".publicKeys = [
    userKey
    # server
  ];
}
