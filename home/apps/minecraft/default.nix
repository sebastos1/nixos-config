{
  pkgs,
  mcsr-nixos,
  ...
}:
let
  mcsrPkgs = mcsr-nixos.packages.${pkgs.system};
  init = pkgs.writeText "init.lua" (
    ''
      package.path = package.path .. ";${mcsrPkgs.waywork}/?.lua"
      local programs = { ninjabrain_bot = "${pkgs.lib.getExe mcsrPkgs.ninjabrain-bot}", }
      local files = { eye_overlay = "${./eye-overlay.png}", }
    ''
    + builtins.readFile ./waywall.lua
  );
in
{
  home.packages = with pkgs; [
    jemalloc
    jdk21
  ];

  programs.prismlauncher = {
    enable = true;
    package =
      with pkgs;
      (prismlauncher.override { additionalPrograms = [ waywall ]; }).overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ makeWrapper ];
        postInstall = (oldAttrs.postInstall or "") + ''
          wrapProgram $out/bin/prismlauncher \
            --set LD_PRELOAD "${jemalloc}/lib/libjemalloc.so"
        '';
      });
  };

  # manual things:
  # use java 21
  # set standardsettings
  # this thing -XX:+UseZGC
  # sys installation of GLFW
  # 26.1 doesn't need patched GLFW, just some java args
  # "waywall wrap --"
  # __GL_THREADED_OPTIMIZATIONS 0 ?
  # feral gamemode ?

  home.file.".config/waywall/init.lua".source = init;
}
