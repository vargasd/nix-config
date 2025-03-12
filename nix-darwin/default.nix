{ pkgs, ... }: {
	# List packages installed in system profile. To search by name, run:
	# $ nix-env -qaP | grep wget
	environment.systemPackages =
		[
			pkgs.ast-grep
			pkgs.bat
			pkgs.brave
			pkgs.btop
			# pkgs.calibre # not supported for darwin
			pkgs.cmake
			pkgs.clang
			pkgs.eza
			pkgs.delta
			pkgs.fd
			pkgs.fzf
			pkgs.git
			pkgs.gnumake
			pkgs.gnupg
			pkgs.jless
			pkgs.jq
			pkgs.lazygit
			pkgs.less
			pkgs.neofetch
			pkgs.neovim
			pkgs.nodejs
			# pkgs.orcaslicer # not available at all (bambu-studio is but only for linux)
			pkgs.rectangle
			pkgs.ripgrep
			pkgs.skhd
			pkgs.sqlite
			pkgs.stow
			pkgs.wezterm
			pkgs.yazi
			pkgs.zoxide
		];

	fonts.packages = [ pkgs.jetbrains-mono ];

	# Necessary for using flakes on this system.
	nix.settings.experimental-features = "nix-command flakes";

	system = {
		# Set Git commit hash for darwin-version.
		configurationRevision = null;

		# Used for backwards compatibility, please read the changelog before changing.
		# $ darwin-rebuild changelog
		stateVersion = 6;

		startup.chime = false;

		defaults = {
			dock = {
				autohide = true;
				autohide-delay = 0.0;
				magnification = true;
				show-recents = false;
				tilesize = 16;
				persistent-apps = [];
			};
			
			NSGlobalDomain = {
				InitialKeyRepeat = 15;
				KeyRepeat = 2;
				"com.apple.swipescrolldirection" = false;
				"com.apple.sound.beep.volume" = 0.0;
				ApplePressAndHoldEnabled = false;
			};
		};

		keyboard = {
			enableKeyMapping = true;
			remapCapsLockToEscape = true;
		};
	};

	# The platform the configuration will be used on.
	nixpkgs.hostPlatform = "aarch64-darwin";
}
