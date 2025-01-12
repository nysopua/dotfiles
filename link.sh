#!/bin/bash

DOTFILES_DIR=~/dotfiles

echo "シンボリックリンクを作成します"

# dotfilesディレクトリ内の二つ下のディレクトリにあるファイルに対してループ
for file in "$DOTFILES_DIR"/*/.[^.]*; do
    # '.' と '..' はスキップ
    if [[ $file == "$DOTFILES_DIR/." || $file == "$DOTFILES_DIR/.." ]]; then
        continue
    fi

    # ホームディレクトリ直下に作成するパスを計算
    link_name=~/${file#"$DOTFILES_DIR"/*/}

    # シンボリックリンクの作成
    ln -sfn "$file" "$link_name"

    # 作成したシンボリックリンクを出力
    echo "リンクを作成: $file -> $link_name"
done

# miseのconfig.tomlをシンボリックリンクとして管理
MISE_CONFIG_SOURCE="$DOTFILES_DIR/mise/config.toml"
MISE_CONFIG_TARGET=~/.mise/config.toml

if [ ! -d "~/.mise" ]; then
    mkdir -p ~/.mise
    echo "~/.mise ディレクトリを作成しました"
fi

ln -sfn "$MISE_CONFIG_SOURCE" "$MISE_CONFIG_TARGET"
echo "miseのconfig.tomlをシンボリックリンクとして設定: $MISE_CONFIG_SOURCE -> $MISE_CONFIG_TARGET"

# miseのconfig.tomlを信頼済みに設定
if command -v mise >/dev/null 2>&1; then
    mise trust "$MISE_CONFIG_TARGET"
    echo "miseのconfig.toml を信頼済みに設定しました"
else
    echo "mise コマンドが見つかりません。mise をインストールしてください。"
fi

echo "シンボリックリンクがホームディレクトリ直下に作成されました"
