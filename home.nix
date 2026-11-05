# Configuración del USUARIO sslozfer (Home Manager)

{ config, pkgs, ... }:

{
  # NO CAMBIAR: versión con la que empezaste a usar Home Manager.
  home.stateVersion = "26.05";

  home.username = "sslozfer";
  home.homeDirectory = "/home/sslozfer";
  
  # Paquetes que solo instalás "para vos", sin configuración especial
  home.packages = with pkgs; [
    rofi
    btop
    fastfetch
    yazi
    pulsemixer
    tty-clock
    wl-clipboard
    awww
    discord

    (writeShellApplication {
      name = "wallpaper-selector";
      runtimeInputs = [ rofi awww kitty git imagemagick findutils coreutils procps ];
      text = builtins.readFile ./dotfiles/scripts/wallpaper-selector.sh;
    })
    
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "sslozfer";
      email = "sslozfer@gmail.com";
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_blur = 1;
      window_padding_width = 1;
      cursor_shape = "beam";
      cursor_blink_interval = 0.5;
      hide_window_decorations = true;
      remember_window_size = true;
      enable_audio_bell = false;
    };
  };

  programs.firefox.enable = true;

  # Hyprland: enlace a tu carpeta del repo, se edita sin rebuild
  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "/home/sslozfer/nixos-config/dotfiles/hypr/hyprland.lua";
  
  # Rofi: copia de solo lectura en el store
  xdg.configFile."rofi" = {
    source = ./dotfiles/rofi;
    recursive = true;   # necesario para poder sumar el archivo de abajo
  };
  
  xdg.configFile."rofi/stylix.rasi".text = with config.lib.stylix.colors; ''
    * {
        font:           "${config.stylix.fonts.monospace.name} ${toString config.stylix.fonts.sizes.popups}";
        background:     #${base00};
        background-alt: #${base01}80;
        foreground:     #${base05};
        selected:       #${base0D};
        active:         #${base0E};
        urgent:         #${base08};
    }
  '';

  stylix.targets.firefox.enable = false;
  stylix.targets.rofi.enable = false;
}
