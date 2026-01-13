{ pkgs, inputs, username, ... }:

{
  # Primary user (required for homebrew and system.defaults)
  system.primaryUser = username;

  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  # System packages (CLI tools)
  environment.systemPackages = with pkgs; [
    bat
    eza
    fd
    fzf
    gh
    git
    just
    ripgrep
    shellcheck
    shfmt
    starship
    tree
  ];

  # Homebrew (for casks and mas apps that Nix can't handle)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";  # Remove unlisted packages
    };
    taps = [];
    brews = [
      "mas"  # Mac App Store CLI
    ];
    casks = [
      "blackhole-2ch"
      "brave-browser"
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "font-monaspace-nerd-font"
      "font-symbols-only-nerd-font"
      "raycast"
      "signal"
      "spotify"
      "visual-studio-code"
      "wezterm"
    ];
    masApps = {
      "GarageBand" = 682658836;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "Kindle" = 302584613;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Xcode" = 497799835;
    };
  };

  # macOS system settings
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
      finder = {
        AppleShowAllFiles = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      dock = {
        autohide = true;
        show-recents = false;
      };
    };
    # Used for backwards compat
    stateVersion = 5;
  };

  # Enable zsh as default shell
  programs.zsh.enable = true;

  # User configuration
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
