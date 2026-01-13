{ pkgs, ... }:

{
  home.stateVersion = "24.05";

  # ユーザーパッケージ
  home.packages = with pkgs; [
    # Node.js
    nodejs_22
    nodePackages.pnpm

    # Rust
    rustup

    # Zsh プラグイン
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions

    # フォント
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.monaspace
    nerd-fonts.symbols-only

    # GUI アプリ (nixpkgs)
    wezterm
    brave
    spotify
    vscode

    # GUI アプリ (brew-nix)
    # 理由: /Applications への配置が必要、または nixpkgs で非対応
    brewCasks.raycast
    brewCasks.signal  # nixpkgs は macOS 非対応
  ];

  # Git 設定
  programs.git = {
    enable = true;
    includes = [
      { path = "~/dotfiles/git/user.conf"; }
    ];
    settings = {
      init.defaultBranch = "main";
      merge.ff = false;
      pull.ff = "only";
    };
  };

  # Zsh 設定
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 30000;
      save = 30000;
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
    };

    shellAliases = {
      c = "clear";
      reload = "exec $SHELL -l";
      ls = "eza -a -i -h --icons=auto --no-user";
      cat = "bat --theme=\"Dracula\"";
      find = "fd";
      grep = "rg";
      g = "git";
    };

    initContent = ''
      # Auto cd
      setopt auto_cd
      setopt auto_pushd
      setopt auto_param_keys
      setopt hist_reduce_blanks

      # fzf cd
      cdf() {
        cd "$(dirname "$(fzf --preview="bat --color=always {}")")"
      }

      # pnpm
      export PNPM_HOME="$HOME/Library/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      # Rust
      [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

      # Language
      export LANG=ja_JP.UTF-8
    '';
  };

  # Starship プロンプト
  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";

      directory.style = "blue";

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };
    };
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # bat
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
    };
  };

  # eza
  programs.eza = {
    enable = true;
  };

  # direnv (devenv で使用)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # WezTerm 設定
  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'
    local config = wezterm.config_builder()

    -- Color scheme
    config.color_scheme = 'Iceberg Dark'

    -- Cursor
    config.default_cursor_style = "BlinkingBlock"

    -- TabBar
    config.hide_tab_bar_if_only_one_tab = false
    config.show_tab_index_in_tab_bar = false

    -- Font
    config.line_height = 1.1
    config.treat_east_asian_ambiguous_width_as_wide = true
    config.font = wezterm.font "MonaspiceAr Nerd Font Mono"

    -- Window
    config.window_close_confirmation = "NeverPrompt"
    config.initial_rows = 50
    config.initial_cols = 150

    return config
  '';
}
