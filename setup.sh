#!/bin/bash

echo "セットアップを開始します"

echo "[1/3] dotfilesのシンボリックリンクを作成しています..."
source ~/dotfiles/link.sh

echo "[2/3] Homebrewの確認とインストール..."
if ! type brew >/dev/null 2>&1; then
  echo "Homebrewをインストールします"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrewはすでにインストールされています"
fi

echo "[3/3] 必要なパッケージと環境設定を実行..."
source ~/dotfiles/brew-init.sh
source ~/dotfiles/replace-zsh.sh
source ~/dotfiles/replace-git.sh

echo "セットアップが完了しました"
echo "Next Steps:"
echo "1. .envを追加し、環境変数を設定してください。"
echo "2. git/user.confを追加し、ユーザー情報を設定してください。"
echo "3. ターミナルを再起動してください。"
