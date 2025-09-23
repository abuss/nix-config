{ config, lib, pkgs, ... }:
with lib.hm.gvariant;
{
  dconf.settings = {
    
    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };

    # "io/github/celluloid-player/celluloid" = {
    #   always-use-floating-controls = true;
    #   csd-enable = true;
    #   dark-theme-enable = true;
    #   settings-migrated = true;
    # };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };
    
    "org/gnome/Weather" = {
      locations = "[<(uint32 2, <('Edmonton', 'CYED', true, [(0.93666003772138751, -1.9803669304139968)], [(0.93462381444296339, -1.9809487010135638)])>)>]";
    };
    
    # "org/gnome/desktop/input-sources" = {
    #   sources = [ (mkTuple [ "xkb" "us+altgr-intl" ]) ];
    # };
    
    # "org/gnome/desktop/background" = {
    #   color-shading-type = "solid";
    #   picture-options = "zoom";
    #   picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/design-is-rounded-rectangles-l.webp";
    #   picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/design-is-rounded-rectangles-d.webp";
    #   primary-color = "#b75e5c";
    #   secondary-color = "#000000";
    # };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "Adwaita";
      font-antialiasing = "rgba";
      font-hinting = "slight";
      font-name = "Work Sans 11";
      gtk-theme = "Adwaita-dark";
      # icon-theme = "ePapirus-Dark";
    };

    "org/gnome/mutter" = {
      #experimental-features = [ "scale-monitor-framebuffer" "x11-randr-fractional-scaling"];
      # experimental-features = [ "scale-monitor-framebuffer" ];
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 7200;
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = [ "<Alt>1" ];
      switch-to-workspace-2 = [ "<Alt>2" ];
      switch-to-workspace-3 = [ "<Alt>3" ];
      switch-to-workspace-4 = [ "<Alt>4" ];
    };
    
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      focus-mode = "sloppy";
      workspace-names = [ "Workspace 1" "Workspace 2" "Workspace 3" "Workspace 4" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ 
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" 
      #      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "ghostty";
      name = "Terminal";
    };

    #"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
    #  binding = "<Alt>Space";
    #  command = "ulauncher-toggle";
    #  name = "Ulauncher";
    #};
    
    "org/gnome/shell" = {
      disabled-extensions = [ ];
      enabled-extensions = [ 
        "appindicatorsupport@rgcjonas.gmail.com" 
        "apps-menu@gnome-shell-extensions.gcampax.github.com" 
        "user-theme@gnome-shell-extensions.gcampax.github.com" 
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com" 
        "dash-to-dock@micxgx.gmail.com" 
      #  "workspace-grid@mathematical.coffee.gmail.com" 
        "kitsch@fopdoodle.net" 
        "blur-my-shell@aunetx"
      ];
      # "system-monitor@paradoxxx.zero.gmail.com" 
      favorite-apps = [ 
        "org.gnome.Epiphany.desktop" 
        "org.gnome.Calendar.desktop" 
        "org.gnome.Nautilus.desktop" 
        "org.gnome.Console.desktop" 
        # "firefox.desktop" 
      ];
     # welcome-dialog-last-shown-version = "44.2";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
      background-opacity = 0.8;
      custom-theme-shrink = true;
      dash-max-icon-size = 32;
      disable-overview-on-startup = true;
      dock-position = "RIGHT";
      height-fraction = 1.0;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "Virtual-1";
    };
    
    "org/gnome/shell/extensions/system-monitor" = {
      battery-show-menu = true;
      compact-display = true;
      cpu-graph-width = 40;
      cpu-show-text = false;
      freq-show-menu = true;
      gpu-show-menu = true;
      icon-display = false;
      memory-display = true;
      memory-graph-width = 40;
      memory-show-text = false;
      net-graph-width = 40;
      net-show-text = false;
      show-tooltip = true;
    };
    
    # "org/x/warpinator/preferences" = {
    #   ask-for-send-permission = true;
    #   autostart = false;
    #   connect-id = "TESTVM-245B6296F9D6D22990F7";
    #   no-overwrite = true;
    #   receiving-folder = "file:///home/abuss/Downloads/Warpinator";
    # };
  };
  
  # gtk = {
  #   # "org/gnome/desktop/input-sources" = {
  #   #   sources = [ (mkTuple [ "xkb" "us+altgr-intl" ]) ];
  #   # };
    
  #   enable = true;

  #   iconTheme = {
  #     name = "ePapirus-Dark";
  #     package = pkgs.papirus-icon-theme;
  #   };

  #   theme = {
  #     name = "Adwaita-dark";
  #     package = pkgs.nordic;
  #   };

  #   #font = {
  #   #  name = "Work Sans 11";
  #   #  package = pkgs.work-sans;
  #   #};
  # };
  
}
