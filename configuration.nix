# Configuración del SISTEMA. Lo personal (programas de usuario, dotfiles) está en home.nix

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Activa flakes y el comando `nix` nuevo
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5; # limite de versiones en el menu de arranque
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_AR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.space-mono
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."sslozfer" = {
    isNormalUser = true;
    description = "sslozfer";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Solo lo básico a nivel sistema. El resto está en home.nix
  environment.systemPackages = with pkgs; [
    git micro python3 uv
  ];

  environment.variables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs.hyprland.enable = true;
  programs.nix-ld.enable = true;

  # Steam necesita cosas a nivel sistema (drivers 32 bits, firewall, udev),
  # por eso se activa acá con `programs.steam` y no como paquete suelto.
  programs.steam.enable = true;

  # --- Home Manager ---
#  home-manager.useGlobalPkgs = true;     # usa el mismo nixpkgs (y allowUnfree) del sistema
#  home-manager.useUserPackages = true;   # instala los paquetes de usuario en el perfil del sistema
#  home-manager.users.sslozfer = import ./home.nix;
#  home-manager.backupFileExtension = "backup";
  
  # NO CAMBIAR: versión con la que se instaló esta máquina.
  system.stateVersion = "26.05";
}
