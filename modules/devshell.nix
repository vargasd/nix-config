{ inputs, self, overlays, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = overlays;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          emmylua-ls
          stylua
          nixd
          nixfmt
        ];

        shellHook =
          let
            luarc = pkgs.mk-luarc-json { plugins = import ../utils/vim-pkgs.nix pkgs; };
          in
          /* bash */ ''
            ln -fs ${luarc} .luarc.json
          '';
      };
    };
}
