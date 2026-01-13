{ pkgs, inputs, username, ... }:

{
  # プライマリユーザー (homebrew と system.defaults に必要)
  system.primaryUser = username;

  # nix-darwin の Nix 管理を無効化 (Determinate Nix を使用)
  nix.enable = false;

  # システムパッケージ (CLI ツール)
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

  # Homebrew (Mac App Store アプリ専用)
  # brew-nix は cask のみ対応、masApps は非対応のため
  # nix-darwin の homebrew モジュール経由で mas CLI を使用
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none";  # 他の homebrew パッケージには触らない
    };
    brews = [ "mas" ];  # masApps に必要
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

  # macOS システム設定
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
    stateVersion = 5;
  };

  # zsh をデフォルトシェルに
  programs.zsh.enable = true;

  # ユーザー設定
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
