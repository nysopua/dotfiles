# dotfiles

Nix + nix-darwin + home-manager で管理する macOS 設定

## 新規セットアップ

### 1. Nix をインストール

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

インストール後、ターミナルを再起動。

### 2. このリポジトリをクローン

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
```

### 3. ローカル設定を作成

> このファイルは `.gitignore` で除外されているため、push されません。

```bash
cat > ~/dotfiles/local.nix << EOF
{
  username = "$(whoami)";
  hostname = "$(hostname -s)";
}
EOF
```

### 4. Git ユーザー設定を作成

> このファイルは `.gitignore` で除外されているため、push されません。

```bash
mkdir -p ~/dotfiles/git
cat > ~/dotfiles/git/user.conf << 'EOF'
[user]
  name = {Your Name}
  email = {your@email.com}
EOF
```

### 5. 既存ファイルがあればバックアップ

```bash
[ -f /etc/zshenv ] && sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup
[ -f ~/.zshenv ] && mv ~/.zshenv ~/.zshenv.backup
```

### 6. nix-darwin を初回ビルド

```bash
cd ~/dotfiles
export DOTFILES_DIR="$HOME/dotfiles"
sudo --preserve-env=DOTFILES_DIR nix run nix-darwin -- switch --flake . --impure
```

sudo パスワードを求められたら入力。

### 7. ターミナルを再起動

新しいターミナルを開けば設定が反映されている。

### 8. Git 設定の確認

`git/user.conf` の設定が反映されているか確認：

```bash
git config user.name
git config user.email
```

## 日常の使い方

### 設定を変更した後

```bash
cd ~/dotfiles && nix run .#switch
```

### パッケージ更新

```bash
cd ~/dotfiles && just update
```

これで以下がすべて更新される：
- nixpkgs (CLI, GUI アプリ)
- brew-nix (raycast, signal)
- homebrew.casks (chrome)
- masApps (Xcode 等)

## プロジェクトごとの開発環境 (devenv)

各プロジェクトで devenv を使う場合：

```bash
cd your-project
nix flake init --template github:cachix/devenv
direnv allow
```

`devenv.nix` を編集して必要なツールを追加。

## ファイル構成

```
~/dotfiles/
├── flake.nix           # エントリポイント
├── flake.lock          # ロックファイル
├── justfile            # 管理コマンド (just switch, just update)
├── local.nix           # ローカル設定 (.gitignore済み)
├── local.nix.example   # ローカル設定のテンプレート
├── nix/
│   ├── darwin.nix      # macOS システム設定
│   └── home.nix        # ユーザー設定 (zsh, git, starship, GUI apps, etc.)
├── git/
│   └── user.conf       # Git ユーザー設定 (.gitignore済み)
└── devenv.nix          # devenv テンプレート
```

## パッケージ管理方針

| 種類 | 管理方法 | 理由 |
|------|---------|------|
| CLI ツール | nixpkgs | 問題なく動作 |
| GUI アプリ | nixpkgs (基本) | 大半は動作する |
| GUI アプリ | brew-nix | `/Applications` 配置が必要、または nixpkgs で macOS 非対応 |
| GUI アプリ | nix-darwin の `homebrew.casks` | brew-nix でハッシュミスマッチが起きる場合 |
| Mac App Store | nix-darwin の `homebrew.masApps` | brew-nix は cask のみ対応、masApps 非対応 |

## カスタマイズ

- **CLIツール追加**: `nix/darwin.nix` の `environment.systemPackages` または `nix/home.nix` の `home.packages`
- **GUIアプリ追加 (nixpkgs)**: `nix/home.nix` の `home.packages` に追加
- **GUIアプリ追加 (brew-nix)**: `nix/home.nix` の `home.packages` に `brewCasks.xxx` を追加
- **GUIアプリ追加 (homebrew)**: `nix/darwin.nix` の `homebrew.casks` に追加 (brew-nix でエラーの場合)
- **Mac App Store追加**: `nix/darwin.nix` の `homebrew.masApps` に追加
- **zsh エイリアス**: `nix/home.nix` の `programs.zsh.shellAliases`
- **macOS 設定**: `nix/darwin.nix` の `system.defaults`
