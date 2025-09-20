{ config, pkgs, ... }: 
{
  environment.systemPackages = [ pkgs.tailscale ];
  
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking = {
    firewall = {
      checkReversePath = "loose";
      allowedUDPPorts = [ config.services.tailscale.port ];
      trustedInterfaces = [ "tailscale0" ];
    };
  };
}
