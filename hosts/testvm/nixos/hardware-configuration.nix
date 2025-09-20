# Hardware configuration
{ config, inputs, lib, modulesPath, pkgs, ... }:
{
  imports = [
    # (modulesPath + "/profiles/quemu-guest.nix")

    # Disk partition definition
    (import ./disks.nix { })
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Enable AMD/Intel microcode
  hardware.enableRedistributableFirmware = true;

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ohci_pci" "ehci_pci" "virtio_pci" "ahci" "usbhid" "sr_mod" "virtio_blk" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    # kernelPackages = pkgs.linuxPackages_latest;
  
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      timeout = 10;
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s9.useDHCP = lib.mkDefault true;
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
