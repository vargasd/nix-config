# Nix Configuration

## NixOS

TODO

## macOS

Using home-manager and not nix-darwin because nix-darwin wasn't adding that much.

### Installation

1. Install nix
1. Add `experimental-features = nix-command flakes pipe-operators` to `/etc/nix/nix.conf`.
1. Install homebrew for GUI/non-nixpkgs apps.
1. Clone this repo.
1. Apply config by running:
   ```sh
   nix run home-manager -- switch --flake .#darwin
   ```
   writing, not time of reading 😅).
1. Switch default shell to fish or keep zsh if you want; they're both supported as of now (time of
1. Log out and back in (or restart) and things should be loaded.
