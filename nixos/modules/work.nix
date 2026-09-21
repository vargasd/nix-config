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

  # https://wiki.nixos.org/wiki/Nix-ld needed for misbehaving node deps
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      ## Put here any library that is required when running a package
      ## ...
      ## Uncomment if you want to use the libraries provided by default in the steam distribution
      ## but this is quite far from being exhaustive
      ## https://github.com/NixOS/nixpkgs/issues/354513
      # (pkgs.runCommand "steamrun-lib" {} "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
    ];
  };

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
