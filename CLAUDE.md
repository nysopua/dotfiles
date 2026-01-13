# Claude Code 用プロジェクト説明

このリポジトリは Nix + nix-darwin + home-manager で macOS を管理する dotfiles。

## パッケージ追加時のルール

「○○をインストールして」と言われたら、以下の優先順位で追加先を決定する：

| 種類 | 追加先 | ファイル |
|------|--------|---------|
| CLI ツール | `environment.systemPackages` | `nix/darwin.nix` |
| GUI アプリ (基本) | `home.packages` に nixpkgs | `nix/home.nix` |
| GUI アプリ (/Applications 必要 or nixpkgs 非対応) | `home.packages` に `brewCasks.xxx` | `nix/home.nix` |
| GUI アプリ (brew-nix でエラー) | `homebrew.casks` | `nix/darwin.nix` |
| Mac App Store アプリ | `homebrew.masApps` | `nix/darwin.nix` |

## 判断フロー

1. まず nixpkgs で探す（`nix search nixpkgs パッケージ名`）
2. nixpkgs にあれば → nixpkgs を使用
3. nixpkgs にない or macOS 非対応 → `brewCasks.xxx` を使用
4. brew-nix でハッシュエラー → `homebrew.casks` を使用
5. Mac App Store 専用 → `homebrew.masApps` を使用

## コメント

コメントは日本語で記述する。

## 適用コマンド

変更後は `cd ~/dotfiles && nix run .#switch` で適用。
