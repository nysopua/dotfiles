# dotfiles 管理コマンド

# 設定を適用
switch:
    cd ~/dotfiles && nix run .#switch

# すべてのパッケージを更新
update:
    cd ~/dotfiles && nix flake update
    cd ~/dotfiles && nix run .#switch
    brew upgrade --cask || true
    mas upgrade || true

# flake.lock のみ更新（適用は別途）
update-flake:
    cd ~/dotfiles && nix flake update
