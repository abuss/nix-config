# testvm home-manager configuration file
{ inputs, outputs, lib, config, pkgs, stateVersion, ...}: 
{
  # You can import other home-manager modules here
  imports = [
    # Console programs configurations
    ./console.nix

    # gnome configuration
    ./gnome.nix
  ];

  # =============================================
  # Package configuration
  # nixpkgs.config.allowUnfree = true;

  # nix = {
  #   # This will add each flake input as a registry
  #   # To make nix3 commands consistent with your flake
  #   # registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

  #   package = pkgs.unstable.nix;
  #   settings = {
  #     auto-optimise-store = true;
  #     experimental-features = [ "nix-command" "flakes" ];
  #     # Avoid unwanted garbage collection when using nix-direnv
  #     keep-outputs = true;
  #     keep-derivations = true;
  #     warn-dirty = false;
  #   };
  # };

  # =============================================
  # Home configuration
  home.username = "abuss";
  home.homeDirectory = "/home/abuss";
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.stateVersion = stateVersion;
  


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
    
    # kitty.settings = {
    #   background_opacity = lib.mkForce "1.0";
    # };

    zsh = {
      enable = true;
      # enableAutosuggestions = true;
      # enableVteIntegration = true;
      # defaultKeymap = "emacs";
      
      # oh-my-zsh = {
      #   enable = true;
	     #  plugins = [ "sudo" ];
	     #  # theme = "dpoggi";
	     #  theme = "lukerandall";
	     #  #theme = "alanpeabody";
      # };
    };
  };

  home.packages = with pkgs; [
    # Browsers
    # firefox
    # unstable.microsoft-edge
    # unstable.google-chrome
    
    # office and graphic
    # gimp-with-plugins
    # gthumb
    # inkscape
    # libreoffice
    # calibre
    # celluloid

    # Development
    # python313
    pyright
    rustup
    gitg
    meld
    uv
    helix
    # emacs29-gtk3
    vscode
    # unstable.vscode-fhs
    # graphviz
    # typst
    # typst-lsp

    # Utils and tools
    # gnome.dconf-editor
    # gnome.simple-scan
    # kitty
    ghostty
    # rustdesk
    megasync
    remmina
    # ulauncher
    # usplay
    # seafile-client

    # Virtualization
    buildah
    podman-compose
    podman-tui
    quickemu
    # for running X11 apps in distrobox
    # xorg.xhost

    # zoom-us
    # barrier
    
  ];

  home = {
    # Face picture
    file.".face".source = ./config/face.png;

    # mc
    # file.".config/mc/ini".source = ./config/mc-ini;
    
    # emacs
    # file.".emacs.d/init.el".source = ./config/emacs-init.el;

    # ULauncher
    # file.".config/ulauncher/settings.json".source = ./config/ulauncher-settings.json;
  
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
