{
  description = "dotfiles managed by Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv";

    # Homebrew casks via Nix
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, devenv, brew-nix, ... }:
    let
      # Import local config (not tracked by git, requires --impure)
      dotfilesDir = builtins.getEnv "DOTFILES_DIR";
      localConfig = import "${dotfilesDir}/local.nix";
      username = localConfig.username;
      hostname = localConfig.hostname;
      system = "aarch64-darwin";

      # Apply brew-nix overlay
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ brew-nix.overlays.default ];
      };
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system pkgs;
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./nix/home.nix;
          }
        ];
        specialArgs = { inherit inputs username pkgs; };
      };

      # nix run .#switch
      apps.${system}.switch = {
        type = "app";
        program = toString (pkgs.writeShellScript "switch" ''
          export DOTFILES_DIR="$HOME/dotfiles"
          sudo --preserve-env=DOTFILES_DIR darwin-rebuild switch --flake ${self} --impure
        '');
      };

      # devenv template for new projects
      devShells.${system}.default = devenv.lib.mkShell {
        inherit inputs;
        pkgs = pkgs;
        modules = [ ./devenv.nix ];
      };
    };
}
