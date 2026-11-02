### nixos-config

Configuración modular de NixOS usando Flakes y Home Manager. 

### Estructura del repositorio

* flake.nix - Entrada principal del sistema y módulos.
* configuration.nix - Configuración global de NixOS (sistema y drivers).
* hardware-configuration.nix - Configuración de hardware específica de la máquina.
* home.nix - Configuración de usuario, paquetes personales y enlaces.
* dotfiles/ - Archivos de configuración de entornos y aplicaciones (Hyprland, Rofi).

### Comandos útiles

### Aplicar cambios en el sistema

bash

git add .
sudo nixos-rebuild switch --flake .#nixos

Usa el código con precaución.

### Forzar actualización ignorando cambios de Git

bash

sudo nixos-rebuild switch --flake path:.#nixos

Usa el código con precaución.

### Limpieza de almacenamiento y generaciones viejas

bash

# Eliminar generaciones previas (conserva las últimas 2)
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +2
nix-env --profile ~/.local/state/nix/profiles/home-manager --delete-generations +2

# Recolectar basura del store
sudo nix-store --gc

# Optimizar enlaces duros duplicados
sudo nix-store --optimise

Usa el código con precaución.

### Replicar en una PC nueva

1. Realizar una instalación mínima de NixOS.
2. Clonar este repositorio.
3. Copiar el archivo de hardware autogenerado de la nueva máquina al repositorio: 

bash

cp /etc/nixos/hardware-configuration.nix ~/nixos-config/

Usa el código con precaución.
4. Desplegar el sistema: 

bash

git add .
sudo nixos-rebuild switch --flake .#nixos

Usa el código con precaución.
