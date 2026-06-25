{ inputs, self, ... }:
let
  home = {
    homeDirectory = "/Users/vargasd";
    user = "vargasd";
    defaultbrowser = "librewolf";
  };
  skhdVars = {
    issues = "open https://github.com/vargasd";
    videoconf = "open -a facetime";
  };
in
{
  flake.homeManagerModules.darwin = {
    _module.args = { inherit home skhdVars; colors = self.colors; };
    imports = [ ../../../home-manager/darwin ];
  };
}
