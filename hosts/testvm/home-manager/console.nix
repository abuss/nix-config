{ config, lib, pkgs, hostname, ... }: 
{
  imports = [ 
  ];
  
  programs = {

    # bat = {
    #   enable = true;
    #   extraPackages = with pkgs.bat-extras; [
    #     batwatch
    #     prettybat
    #   ];
    # };
    
    dircolors = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
  
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          features = "decorations";
          navigate = true;
          side-by-side = true;
        };
      };
    
      aliases = {
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    
      extraConfig = {
        push = {
          default = "matching";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
      };
    
      ignores = [
        "*.log"
        "*.out"
        ".DS_Store"
        "bin/"
        "dist/"
        "result"
      ];
    };
    
    gpg.enable = true;
    info.enable = true;
    jq.enable = true;

    # powerline-go = {
    #   enable = false;
    #   settings = {
    #     cwd-max-depth = 5;
    #     cwd-max-dir-size = 10;
    #     max-width = 50;
    #     condensed = true;
    #     # cwd-mode = "plain"; # fancy, semifancy, plain, dironly
    #     git-mode = "simple"; # fancy, compact, simple
    #   };
    # };
  };

  home.packages = with pkgs; [
    dconf2nix # Nix code from Dconf files
    diffr # Modern Unix `diff`
    difftastic # Modern Unix `diff`
    dua # Modern Unix `du`
    duf # Modern Unix `df`
    du-dust # Modern Unix `du`
    entr # Modern Unix `watch`
    fd # Modern Unix `find`
    ffmpeg-headless # Terminal video encoder
    glow # Terminal Markdown renderer
    gping # Modern Unix `ping`
    hyperfine # Terminal benchmarking
    jiq # Modern Unix `jq`
    lazygit # Terminal Git client
    lurk # Modern Unix `strace`
    moar # Modern Unix `less`
    neofetch # Terminal system info
    nurl # Nix URL fetcher
    ripgrep # Modern Unix `grep`
    tldr # Modern Unix `man`
    wget # Terminal downloader
    yq-go # Terminal `jq` for YAML
    dotter # Local config manager
  ];

}
