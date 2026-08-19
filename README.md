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

### Generating ISO

Generate ISO:
```sh
nix run nixpkgs#nixos-generators -- --format iso --flake .#iso -o .samignore/iso
```

Copy to USB (use `lsblk` first):
```sh
sudo dd if=./.samignore/iso/iso/*.iso of=/dev/sdX bs=4M status=progress conv=fdatasync
```

### Disko-ing from scratch

Set up disko for the host.
Generally, build an iso and pull down this repo.

```sh
nix run github:nix-community/disko/latest -- --flake .#<flake-attr> --disk <disk-name> <disk-device>
```

e.g.
```sh
nix run github:nix-community/disko/latest -- --flake .#thia --disk main nvme0n1
```

This will partition and install the flake for the new setup. Afterwards enroll remaining Yubikeys via:

```sh
sudo systemd-cryptenroll /dev/nvme0n1p2 \
  --fido2-device=/dev/hidraw1 \
  --fido2-with-client-pin=yes \
  --fido2-with-user-presence=yes \
  --unlock-fido2-device=/dev/hidraw0

```

Use `ls /dev/hidraw*` and plug around to figure out which Yubikey is which
