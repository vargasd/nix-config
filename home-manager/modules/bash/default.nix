{ pkgs, config, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    historyControl = [ "ignoreboth" ];
    historySize = 50000;
    historyFileSize = 50000;

    bashrcExtra =
      builtins.readFile ./shared.sh
      + builtins.readFile ./init.bash
      + ''
        source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
      '';

    shellAliases = {
      nixpkgs-search = # sh
        ''
          nix search nixpkgs --no-write-lock-file --reference-lock-file ${../../../flake.lock} ^ --json 2> /dev/null | \
          jq -r 'to_entries | .[] | ((.key | sub("^legacyPackages.[^.]*."; "")) + ": " + .value.description)' | \
          fzf --multi --bind 'enter:become(cut -d : -f 1 {+f})'
        '';
    };
  };
}
