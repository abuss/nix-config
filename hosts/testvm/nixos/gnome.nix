# GNOME configuration
{ config, pkgs, ... }: 
{

  programs.dconf.enable = true;

  # Enable the X11 windowing system using GNOME
  services.xserver = {
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.wayland = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };

    excludePackages = [ pkgs.xterm pkgs.gnome-tour ];
    desktopManager.xterm.enable = false;
  };

  # Add GNOME packages
  environment.systemPackages = (with pkgs; [
    # AppImage support & X11 automation
    appimage-run

    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome-browser-connector

    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.tailscale-qs
    gnomeExtensions.astra-monitor
    
    # gnomeExtensions.system-monitor
    # gnomeExtensions.tailscale-status
    # gnomeExtensions.system-monitor-next
    # gnomeExtensions.pop-shell
    # gnomeExtensions.pano
    # gnomeExtensions.pop-launcher-super-key
  ]);

  # Remove GNOME packages
  environment.gnome.excludePackages = (with pkgs; [
    geary
    gnome-photos
    gnome-tour
  ]);

  # Services
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

}
