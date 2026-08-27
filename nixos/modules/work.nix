{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.sentinelone.nixosModules.sentinelone
  ];

  services.sentinelone = {
    enable = true;
    sentinelOneManagementTokenPath = "/etc/secrets/sentinelone-key"; # TODO: Should use sops. Need to write token from pass in plaintext :/
    package = pkgs.sentinelone.overrideAttrs (old: {
      version = "25.2.2.14";
      src = pkgs.fetchurl {
        url = "https://github.com/ocs-eb1/ocs-epdr/raw/refs/heads/main/pkgs/SentinelAgent_linux_x86_64_v25_2_2_14.deb";
        hash = "sha256-ZWtuJ/ua2roIz2I/4CicnVXlc1Sj5w/r412pS5KfmOA=";
      };
    });
  };

  networking.openconnect.interfaces.vpn = {
    gateway = "aovpn.ostra.net";
    protocol = "gp";
    user = "sam.varga@championhq.com";
    passwordFile = "/etc/secrets/openconnect-password";
    autoStart = true;
    extraOptions = {
      authgroup = "AlwaysOn";
      local-hostname = config.networking.hostName;
    };
  };
}
