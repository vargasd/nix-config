{ inputs, self, ... }:
let
  home = {
    homeDirectory = "/Users/I763291";
    user = "I763291";
    defaultbrowser = "firefox";
  };
  skhdVars = {
    issues = "open 'https://emarsys.jira.com/jira/software/c/projects/SC/boards/1088?quickFilter=3743'";
    videoconf = "open -a 'Microsoft Teams'";
  };
in
{
  flake.homeManagerModules.work = {
    _module.args = { inherit home skhdVars; colors = self.colors; };
    imports = [ ../../../home-manager/darwin/work.nix ];
    nixpkgs.config.allowUnfree = true;
  };
}
