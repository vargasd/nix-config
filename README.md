# My nix configuration

So far, it's just nix-darwin. For now, I'm using nix on a trial basis, particularly since MacOS setting management is not so great.

## nix-darwin

1. [Install nix via Determinate Systems](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer) as described [here](https://github.com/LnL7/nix-darwin/blob/master/README.md#prerequisites).
2. [Install homebrew](https://brew.sh/) since that's how we'll install GUI apps (and maybe some Mac-specific binaries at some point?)

Apply by running

	darwin-rebuild switch --flake .#sams-Mac-mini
