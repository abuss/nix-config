{ lib, pkgs, username, ... }: {
  imports = [
    # Services
    # ./services/fwupd.nix
    # ./services/kmscon.nix
    # ./services/openssh.nix
    # ./services/pipewire.nix
    # ./services/smartmon.nix
    # ./services/networkmanager.nix
    # ./services/automount.nix # TODO
    # ./services/firewall.nix
    # ./services/cups.nix
    # ./services/sane.nix
    # ./services/avahi.nix
    # ./services/bluetooth.nix
    # ./services/flatpak.nix
    # ./services/tailscale.nix # TODO
  ];

  environment = {
    systemPackages = with pkgs; [
        # agenix
        bash
        binutils
        curl
        file
        git
        home-manager
        killall
        man-pages
        pciutils
        rsync
        unzip
        usbutils
        wget
        xdg-utils
        cifs-utils
        desktop-file-utils
        neovim
        micro
        mc
        gtop

        # pipewire support
        alsa-utils
        pulseaudio
        pulsemixer
        pavucontrol

        # Smart monitor
        nvme-cli
        smartmontools
        gsmartcontrol
    ];
  };
}
