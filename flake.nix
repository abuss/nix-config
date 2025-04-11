{
  description = "My Simple NixOS and Home Manager Configuration";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    # nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware definition
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # nix-colors.url = "github:misterio77/nix-colors";

  };

  outputs =
    # { self, nix-formatter-pack, nixpkgs, home-manager, ...} @ inputs:
    { self, nixpkgs, home-manager, ...} @ inputs:
    let
      inherit (self) outputs;
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "24.11";

      username = "abuss";

      # Supported systems for your flake packages, shell, etc.
      systems = [
        "x86_64-linux"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {

      nixosConfigurations = {
        # Workstations
        #  - sudo nixos-rebuild switch --flake $HOME/.dotfiles/nix-config
        #  - nix build .#nixosConfigurations.ripper.config.system.build.toplevel
        # Test
        testvm = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/testvm/nixos/configuration.nix ];  
        };

        eszkoz = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/eszkoz/nixos/configuration.nix ];  
        };

        miniws = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/miniws/nixos/configuration.nix ];  
        };

        homecloud = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/homecloud/nixos/configuration.nix ];  
        };
      };

      # home-manager switch -b backup --flake $HOME/.dotfiles/nix-config
      # nix build .#homeConfigurations."abuss@nixosvm".activationPackage
      homeConfigurations = {
        "abuss@testvm" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/testvm/home-manager/home.nix ];
        };

        "abuss@eszkoz" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/eszkoz/home-manager/home.nix ];
        };

        "abuss@miniws" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/miniws/home-manager/home.nix ];
        };

        "abuss@homecloud" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/homecloud/home-manager/home.nix ];
        };
      };

      # Devshell for bootstrapping; acessible via 'nix develop' or 'nix-shell' (legacy)
      # devShells = forAllSystems (system:
      #   let pkgs = nixpkgs.legacyPackages.${system};
      #   in import ./shell.nix { inherit pkgs; }
      # );

      # Custom packages and modifications, exported as overlays
      # overlays = import ./overlays { inherit inputs; };

      # Custom packages; acessible via 'nix build', 'nix shell', etc
      # packages = forAllSystems (system:
      #   let pkgs = nixpkgs.legacyPackages.${system};
      #   in import ./pkgs { inherit pkgs; }
      # );
    };
}
