{ lib, pkgs, username, ... }: {
  imports = [
    # Services
   # ./services/tailscale.nix # TODO
  ];

  environment = {
    # sessionVariables.NIXOS_OZONE_WL = "1";
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
        # wireguard-tools
        helix
        tmux
        
        # pipewire support
        alsa-utils
        pulseaudio
        pulsemixer
        pavucontrol

        # Smart monitor
        nvme-cli
        smartmontools
        gsmartcontrol
        lm_sensors

        runc
        # slirp4netns
        # umoci
        uv
    ];
  };
}
