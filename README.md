# Nix Configuration

## `nix-darwin`

### Installation

1. Install lix
   1. This errors but running again has done the trick in the pashas done the trick in the past.
   1. You can use Determinate Nix too, but either disable FileVault or use the installer package over the script.
1. Add `pipe-operator` (lix) or `pipe-operators` (nix) experimental feature to `/etc/nix/nix.conf`.
1. Install homebrew for GUI apps.
1. Clone this repo (over HTTP).
1. Apply config by running:
   ```sh
   sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#home
   ```
1. Log out and back in (or restart) and things should be loaded.

### Manual Things

Set Homerow shortcut manually. See note in [./home-manager/darwin.nix](./home-manager/darwin.nix).
Add Night Shift to Control Center
Remove desktop widgets 👎
