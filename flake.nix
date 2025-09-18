{
  description = "My Simple NixOS and Home Manager Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
        url = "github:nix-community/home-manager/release-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hardware definition
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { self, nixpkgs, home-manager, ...} @ inputs:
    let
      inherit (self) outputs;
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "25.05";

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
        #  - sudo nixos-rebuild switch --flake $HOME/.dotfiles/nix-config#testvm
        # Test vm
        testvm = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs stateVersion username;};
          modules = [
            # nixos-hardware.nixosModules.framework-13-7040-amd
            ./hosts/testvm/nixos/configuration.nix
          ];
        };

        eszkoz = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs stateVersion username;};
          modules = [
            # nixos-hardware.nixosModules.framework-13-7040-amd
            ./hosts/eszkoz/nixos/configuration.nix
          ];
        };

        # miniws = nixpkgs.lib.nixosSystem {
        #   specialArgs = {inherit inputs outputs stateVersion username;};
        #   modules = [ ./hosts/miniws/nixos/configuration.nix ];  
        # };

        # homecloud = nixpkgs.lib.nixosSystem {
        #   specialArgs = {inherit inputs outputs stateVersion username;};
        #   modules = [ ./hosts/homecloud/nixos/configuration.nix ];  
        # };
      };

      # home-manager switch -b backup --flake $HOME/.dotfiles/nix-config
      # nix build .#homeConfigurations."abuss@nixosvm".activationPackage
      homeConfigurations = {
        "abuss@testvm" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/testvm/home-manager/home.nix ];
        };

        "abuss@eszkoz" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs stateVersion username;};
          modules = [ ./hosts/eszkoz/home-manager/home.nix ];
        };

        # "abuss@miniws" = home-manager.lib.homeManagerConfiguration {
        #   pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #   extraSpecialArgs = {inherit inputs outputs stateVersion username;};
        #   modules = [ ./hosts/miniws/home-manager/home.nix ];
        # };

        # "abuss@homecloud" = home-manager.lib.homeManagerConfiguration {
        #   pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #   extraSpecialArgs = {inherit inputs outputs stateVersion username;};
        #   modules = [ ./hosts/homecloud/home-manager/home.nix ];
        # };
      };

    };
}
