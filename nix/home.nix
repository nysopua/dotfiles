{ pkgs, ... }:

{
  home.stateVersion = "24.05";

  # ユーザーパッケージ
  home.packages = with pkgs; [
    # Node.js
    nodejs_22
    nodePackages.pnpm
    opencommit

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

    # claude
    (lib.hiPrio claude-code)

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
      # WezTerm を現在のディレクトリで開く（code . と同じ使い勝手）
      wez() {
        local target="''${1:-$PWD}"

        # ファイルが指定された場合はそのディレクトリを使用
        [[ -f "$target" ]] && target=$(dirname "$target")

        [[ "$target" != /* ]] && target="$PWD/$target"
        local dir=$(cd "$target" 2>/dev/null && pwd) || { echo "wez: $1: No such directory" >&2; return 1; }

        # WezTerm GUI プロセスが動いているかチェック
        if pgrep -q wezterm-gui; then
          wezterm cli spawn --new-window --cwd "$dir" &>/dev/null
          osascript -e 'tell application "WezTerm" to activate' &>/dev/null
        else
          # 未起動: start で起動し、前面に表示
          wezterm start --cwd "$dir" &>/dev/null &
          (
            # wezterm-gui プロセスが起動するまで待機
            while ! pgrep -q wezterm-gui; do sleep 0.05; done
            osascript -e 'tell application "WezTerm" to activate'
          ) &>/dev/null &
        fi
      }

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
  xdg.configFile."wezterm" = {
    source = ../wezterm;
    recursive = true;
  };

}
