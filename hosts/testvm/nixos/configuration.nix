# System configuration for testvm
{ config, inputs, lib, outputs, pkgs, stateVersion, username, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko

    # Hardware and partition configuration
    ./hardware-configuration.nix

    # Services and Packages
    ./packages.nix
  ];
  
  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # nix = {
  #   gc = {
  #     automatic = true;
  #     options = "--delete-older-than 10d";
  #   };

  #   optimise.automatic = true;

  #   settings = {
  #     auto-optimise-store = true;

  #     # Enabling flakes
  #     experimental-features = [ "nix-command" "flakes" ];
      
  #     # Avoid unwanted garbage collection when using nix-direnv
  #     keep-outputs = true;
  #     keep-derivations = true;

  #     warn-dirty = false;
  #   };
  # };

  # boot = {
  #   consoleLogLevel = 0;
  #   initrd.verbose = false;
  #   kernelModules = [ "vhost_vsock" ];
  #   kernelParams = [
  #     "boot.shell_on_fail"
  #     "loglevel=3"
  #     "rd.systemd.show_status=false"
  #     "rd.udev.log_level=3"
  #     "udev.log_priority=3"
  #   ];
  #   kernel.sysctl = {
  #     "net.ipv4.ip_forward" = 1;
  #     "net.ipv6.conf.all.forwarding" = 1;
  #   };
  # };

  # TODO: Use passed hostname to configure basic networking
  networking = {
    hostName = "testvm";
    useDHCP = lib.mkDefault true;

    networkmanager = {
      enable = true;
      # wifi = {
      #   backend = "iwd";
      # };
    };

    firewall.enable = false;
  };


  hardware = {
    pulseaudio.enable = false;

  #   sane = {
  #       enable = true;
  #       extraBackends = with pkgs; [ sane-airscan ];
  #   };
  
    # https://nixos.wiki/wiki/Bluetooth
    bluetooth = {
        enable = true;
        package = pkgs.bluez;
        settings = {
            General = {
                Enable = "Source,Sink,Media,Socket";
            };
        };
    };
  };

    # Locale
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    extraLocaleSettings = {
    LC_ADDRESS = "en_CA.UTF-8";
    LC_IDENTIFICATION = "en_CA.UTF-8";
    LC_MEASUREMENT = "en_CA.UTF-8";
    LC_MONETARY = "en_CA.UTF-8";
    LC_NAME = "en_CA.UTF-8";
    LC_NUMERIC = "en_CA.UTF-8";
    LC_PAPER = "en_CA.UTF-8";
    LC_TELEPHONE = "en_CA.UTF-8";
    LC_TIME = "en_CA.UTF-8";
    };
  };

  time.timeZone = "America/Edmonton";  

  # Enable the X11 windowing system.
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

  # Only install the docs I use
  documentation = {
    enable = true;
    nixos.enable = false;
    man.enable = true;
    info.enable = false;
    doc.enable = false;
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # (nerdfonts.override { fonts = [ "FiraCode" "SourceCodePro" "UbuntuMono" ]; })
      fira
      fira-code-symbols
      # liberation_ttf
      # noto-fonts-emoji
      source-serif
      # ubuntu_font_family
      work-sans
    ];

    # Enable a basic set of fonts providing several font styles and families and reasonable coverage of Unicode.
    # enableDefaultFonts = true;
    # enableDefaultFonts = false;

    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = [ "Source Serif" ];
        sansSerif = [ "Work Sans" "Fira Sans" "FiraGO" ];
        monospace = [ "FiraCode Nerd Font Mono" "SauceCodePro Nerd Font Mono" ];
        emoji = [ "Joypixels" "Noto Color Emoji" ];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };


  # Services
  services = {
    # Firmware update
    fwupd.enable = true;
    
    openssh = {
        enable = true;
        settings = {
          # PasswordAuthentication = false;
          PermitRootLogin = lib.mkDefault "no";
        };
    };

    pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # wireplumber.enable = true;
        # jack.enable = false;
    };

    avahi = {
        enable = true;
        nssmdns = true;
        publish = {
            enable = true;
            domain = true;
            userServices = true;
        };
    };

    printing.enable = true;
    # printing.drivers = with pkgs; [ gutenprint ];

    # blueman.enable = true;

    flatpak.enable = true;
  };


  environment.shells = with pkgs; [ zsh ];

  programs = {
    command-not-found.enable = false;
    
    # ZSH
    zsh = {
      enable = true;
      
      shellAliases = {
        nix-gc = "sudo nix-collect-garbage --delete-older-than 14d";
        rebuild-all = "sudo nix-collect-garbage --delete-older-than 14d && sudo nixos-rebuild switch --flake $HOME/.dotfiles/nix-config && home-manager switch -b backup --flake $HOME/.dotfiles/nix-config";
        rebuild-home = "home-manager switch -b backup --flake $HOME/.dotfiles/nix-config";
        rebuild-host = "sudo nixos-rebuild switch --flake $HOME/.dotfiles/nix-config";
        rebuild-lock = "pushd $HOME/.dotfiles/nix-config && nix flake lock --recreate-lock-file && popd";
    
        open = "xdg-open";
        # pubip = "curl -s ifconfig.me/ip";
      };
    };

    starship.enable = true;
  
    ssh.startAgent = true;
  };


  # xdg.portal = {
    # enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gtk
  #   ];
  #   # xdgOpenUserPortal = true;
  # };

  # Create dirs for home-manager
  systemd = {
    # tmpfiles.rules = [
    #     "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root"
    #     "d /mnt/snapshot/${username} 0755 ${username} users"
    # ];
    
    # Workaround https://github.com/NixOS/nixpkgs/issues/180175
    services.NetworkManager-wait-online.enable = false;

    services.configure-flathub-repo = {
        wantedBy = ["multi-user.target"];
        path = [ pkgs.flatpak ];
        script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        '';
    };
  };

  # ------ Users ----------
  users.users.root = {
    hashedPassword = null;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOA6V+TZJ+BmBAU4FB0nbhYQ9XOFZwCHdwXTuQkb77sPi6fVcbzso5AofUc+3DhfN56ATNOOslvjutSPE8kIp3Uv91/c7DE0RHoidNl3oLre8bau2FT+9AUTZnNEtWH/qXp5+fzvGk417mSL3M5jdoRwude+AzhPNXmbdAzn08TMGAkjGrMQejXItcG1OhXKUjqeLmB0A0l3Ac8DGQ6EcSRtgPCiej8Boabn21K2OBfq64KwW/MMh/FWTHndyBF/lhfEos7tGPvrDN+5G05oGjf0fnMOxsmAUdTDbtOTTeMTvDwjJdzsGUluEDbWBYPNlg5wacbimkv51/Bm4YwsGOkkUTy6eCCS3d5j8PrMbB2oNZfByga01FohhWSX9bv35KAP4nq7no9M6nXj8rQVsF0gPndPK/pgX46tpJG+pE1Ul6sSLR2jnrN6oBKzhdZJ54a2wwFSd207Zvahdx3m9JEVhccmDxWltxjKHz+zChAHsqWC9Zcqozt0mDRJNalW8fRXKcSWPGVy1rfbwltiQzij+ChCQQlUG78zW8lU7Bz6FuyDsEFpZSat7jtbdDBY0a4F0yb4lkNvu+5heg+dhlKCFj9YeRDrnvcz94OKvAZW1Gsjbs83n6wphBipxUWku7y86iYyAAYQGKs4jihhYWrFtfZhSf1m6EUKXoWX87KQ== antal.buss@gmail.com"
    ];
  };

  users.users.abuss = {
    description = "Antal Buss";
    initialPassword = "abuss";
    extraGroups = 
        let
            ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
        in
            [ "audio" "input" "networkmanager" "users" "video" "wheel" ] 
            ++ ifExists [ "docker" "podman"];

    # mkpasswd -m sha-512
    # hashedPassword = "$6$UXNQ20Feu82wCFK9$dnJTeSqoECw1CGMSUdxKREtraO.Nllv3/fW9N3m7lPHYxFKA/Cf8YqYGDmiWNfaKeyx2DKdURo0rPYBrSZRL./";
    homeMode = "0755";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOA6V+TZJ+BmBAU4FB0nbhYQ9XOFZwCHdwXTuQkb77sPi6fVcbzso5AofUc+3DhfN56ATNOOslvjutSPE8kIp3Uv91/c7DE0RHoidNl3oLre8bau2FT+9AUTZnNEtWH/qXp5+fzvGk417mSL3M5jdoRwude+AzhPNXmbdAzn08TMGAkjGrMQejXItcG1OhXKUjqeLmB0A0l3Ac8DGQ6EcSRtgPCiej8Boabn21K2OBfq64KwW/MMh/FWTHndyBF/lhfEos7tGPvrDN+5G05oGjf0fnMOxsmAUdTDbtOTTeMTvDwjJdzsGUluEDbWBYPNlg5wacbimkv51/Bm4YwsGOkkUTy6eCCS3d5j8PrMbB2oNZfByga01FohhWSX9bv35KAP4nq7no9M6nXj8rQVsF0gPndPK/pgX46tpJG+pE1Ul6sSLR2jnrN6oBKzhdZJ54a2wwFSd207Zvahdx3m9JEVhccmDxWltxjKHz+zChAHsqWC9Zcqozt0mDRJNalW8fRXKcSWPGVy1rfbwltiQzij+ChCQQlUG78zW8lU7Bz6FuyDsEFpZSat7jtbdDBY0a4F0yb4lkNvu+5heg+dhlKCFj9YeRDrnvcz94OKvAZW1Gsjbs83n6wphBipxUWku7y86iYyAAYQGKs4jihhYWrFtfZhSf1m6EUKXoWX87KQ== antal.buss@gmail.com"
    ];
    # packages = [ pkgs.home-manager ];
    
    # shell = pkgs.fish;
    
    shell = pkgs.zsh;
  };

  system.stateVersion = stateVersion;
};

