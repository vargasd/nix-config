# TODO: move these out to their appropriate places
{ inputs, ... }:
let
  overlays = [
    inputs.gen-luarc.overlays.default
    inputs.enhansi.overlays.default
    inputs.niri-flake.overlays.niri
    (final: prev: {
      zmx = inputs.zmx.packages.${final.system}.zmx;
    })
  ];
in
{
  _module.args.overlays = overlays;
}
