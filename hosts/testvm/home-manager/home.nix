# My home-manager configuration file
{ inputs, outputs, lib, config, pkgs, stateVersion, ...}: 
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModules.default
    
    # Console programs configurations
    ./console.nix

    # gnome configuration
    ./gnome.nix
  ];

  # =============================================
  # Package configuration
  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    package = pkgs.unstable.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
      warn-dirty = false;
    };
  };

  # =============================================
  # Home configuration
  home = {
    homeDirectory = "/home/abuss";
    username = "abuss";
    sessionPath = [ "$HOME/.local/bin" ];
    inherit stateVersion;
  };


  # =============================================
  # Progrmas

  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
    
    git = {
      enable = true;
      userEmail = "antal.buss@gmail.com";
      userName = "Antal Buss";
    };

    neovim.enable = true;
    
    kitty.settings = {
      background_opacity = lib.mkForce "1.0";
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableVteIntegration = true;
      defaultKeymap = "emacs";
      
      oh-my-zsh = {
        enable = true;
	      plugins = [ "sudo" ];
	      # theme = "dpoggi";
	      theme = "lukerandall";
	      #theme = "alanpeabody";
      };
    };
  };

  home.packages = with pkgs; [
    # Browsers
    unstable.firefox
    # unstable.microsoft-edge
    # unstable.google-chrome
    
    # office and graphic
    # gimp-with-plugins
    gthumb
    # inkscape
    # libreoffice
    # calibre
    celluloid

    # Development
    python311
    pyright
    rustup
    # gitg
    # meld
    emacs29-gtk3
    # unstable.vscode
    unstable.vscode-fhs
    # graphviz
    # typst
    # typst-lsp

    # Utils and tools
    gnome.dconf-editor
    # gnome.simple-scan
    kitty
    # rustdesk
    # megasync
    # remmina
    ulauncher
    # usplay

    # Virtualization
    buildah
    podman-compose
    podman-tui
    unstable.quickemu
    # for running X11 apps in distrobox
    xorg.xhost

    # zoom-us
    # barrier
    
  ];

  home = {
    # Face picture
    file.".face".source = ./config/face.png;

    # mc
    file.".config/mc/ini".source = ./config/mc-ini;
    
    # emacs
    file.".emacs.d/init.el".source = ./config/emacs-init.el;

    # ULauncher
    file.".config/ulauncher/settings.json".source = ./config/ulauncher-settings.json;
  
  };

  # =============================================
  # Services
  
  services = {

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "curses";
    };

    syncthing = {
      enable = true;
      extraOptions = [
        "--gui-address=0.0.0.0:8384"
        "--no-default-folder"
        "--no-browser"
      ];
      # tray = {
      #   enable = true;
      #   package = pkgs.unstable.syncthingtray;
      # };
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = lib.mkDefault true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
      };
    };
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  # home.stateVersion = "23.05";
}
