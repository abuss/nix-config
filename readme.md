# My NixOS configuration

To build a host:

        $ sudo nixos-rebuild switch --flake .#nixosvm

To build a home manager user:

        $ home-manager switch --flake .#abuss@nixosvm

After installation, rebuild host and home can be done using:

        $ rebuild-host

        $ rebuild-home

## Directory structure

- home-manager
    - Apps
        - Browsers
        - Console
        - Development
        - Editors
        - Media
        - Tools
        - Utility
        - Virtualization
    - Desktop
    - Services
    - Users

    * default:
        [
            base
            desktop
            user
        ]


- nixos
    - hosts: Machine specification (disk, H/W specs, etc) 
    - users: user configurations (passwd, permisions, etc)
    - base : minimum apps and services
    - modules
        - apps
            - cli
            - desktop 
        - services
        - lang
        - desktop: WM, exclude apps, general apps

    * default: 
        [
            host
            base (apps, services, desktop?)
            users (root,abuss)
        ]


- Mozgo
    - base
    - desktop
    - user (home-manager)
        - apps (boundle pkgs+config)
        - services (boundle pkgs+config)