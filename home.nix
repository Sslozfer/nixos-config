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

    font.name = "SpaceMono Nerd Font";
    font.size = 11;

    settings = {
      # Transparencia (0.0 totalmente transparente, 1.0 opaco)
      background_opacity = 0.95;

      # Desenfocar el fondo (solo funciona en algunos entornos)
      background_blur = 1;

      # Margen interno de la ventana
      window_padding_width = 1;

      # Colores (Catppuccin Mocha)
      background = "#1e1e2e";
      foreground = "#cdd6f4";

      # Selección
      selection_background = "#313244";
      selection_foreground = "#cdd6f4";

      # Cursor
      cursor = "#f5e0dc";
      cursor_shape = "beam";
      cursor_blink_interval = 0.5;

      # Ocultar la barra de título nativa
      hide_window_decorations = true;

      # Recordar el tamaño de la ventana anterior
      remember_window_size = true;

      # Desactivar el pitido del sistema
      enable_audio_bell = false;
    };
  };

  programs.firefox.enable = true;

  # Hyprland: enlace a tu carpeta del repo, se edita sin rebuild
  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "/home/sslozfer/nixos-config/dotfiles/hypr/hyprland.lua";
  
  # Rofi: copia de solo lectura en el store
  xdg.configFile."rofi".source = ./dotfiles/rofi;
}
