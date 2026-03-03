#!/bin/bash

echo "=== 1. 公式パッケージのインストール ==="
sudo pacman -S --needed - < pkglist.txt

echo "=== 2. yayの準備とAURパッケージのインストール ==="
if ! command -v yay &> /dev/null; then
    echo "yayをインストールしています..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi
yay -S --needed - < aurlist.txt

echo "=== 3. 設定ファイル（Dotfiles）の復元 ==="
mkdir -p ~/.config
cp -r config/* ~/.config/
# ※.bashrcはAPIキー保護のため除外しています。新しいPCで手動設定してください。

echo "=== 4. SDDM（ログイン画面）の有効化 ==="
if [ -f "etc/sddm.conf" ]; then
    sudo cp etc/sddm.conf /etc/
elif [ -d "etc/sddm.conf.d" ]; then
    sudo cp -r etc/sddm.conf.d /etc/
fi
sudo systemctl enable sddm

echo "=== 移行が完了しました！再起動してください ==="
echo "※HEUSCなどの開発で使う OpenAI APIキー 等の環境変数は、再起動後に ~/.bashrc へ手動で追記してください。"
