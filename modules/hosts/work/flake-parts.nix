{ inputs, ... }:
{
  flake.homeConfigurations = inputs.self.lib.mkHomeManager "aarch64-darwin" "work";
}
