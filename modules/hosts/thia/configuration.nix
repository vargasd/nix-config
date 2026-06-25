{ inputs, self, overlays, ... }:
let
  user = "vargasd";
  home = {
    homeDirectory = "/home/vargasd";
    inherit user;
  };
in
{
  flake.modules.nixos.thia = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      ../../../nixos/thia.nix
    ];
    _module.args = { inherit home; colors = self.colors; };
    nixpkgs.overlays = overlays;
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.sharedModules = [
      { _module.args = { inherit home; colors = self.colors; }; }
    ];
    home-manager.users.${user} = import ../../../home-manager/nixos.nix;
  };
}
