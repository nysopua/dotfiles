# dotfiles 管理コマンド

# 設定を適用
switch:
    cd ~/dotfiles && nix run .#switch

# すべてのパッケージを更新（Xcode除く）
update:
    cd ~/dotfiles && nix flake update
    cd ~/dotfiles && nix run .#switch
    brew upgrade --cask || true
    mas outdated | grep -v "497799835" | cut -d' ' -f1 | xargs -I {} mas upgrade {} || true

# flake.lock のみ更新（適用は別途）
update-flake:
    cd ~/dotfiles && nix flake update

# VSCode 拡張機能のみ更新
update-vscode:
    cd ~/dotfiles && nix flake update nix-vscode-extensions
    cd ~/dotfiles && nix run .#switch

# Xcode のみ更新（App Store で手動更新）
update-xcode:
    @echo "App Store → アップデート → Xcode を更新してください"
    open -a "App Store"
