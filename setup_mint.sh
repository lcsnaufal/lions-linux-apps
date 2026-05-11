#!/bin/bash

set -e

echo "========================================"
echo "🚀 Iniciando configuração do Linux Mint..."
echo "========================================"

# 1. Atualiza a lista de pacotes
echo "📦 Atualizando os repositórios..."
sudo apt update -y

# 2. Desinstala o Firefox (APT e Flatpak)
echo "🦊 Removendo o Firefox..."
sudo apt purge -y firefox firefox-locale-* || true
flatpak uninstall --delete-data -y org.mozilla.firefox || true

# 3. Baixa e instala o Google Chrome
echo "🌐 Baixando e instalando o Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
sudo apt install -y /tmp/google-chrome.deb
rm /tmp/google-chrome.deb

# 4. Instala o LibreOffice
echo "📄 Instalando o LibreOffice..."
sudo apt install -y libreoffice libreoffice-l10n-pt-br

# 5. Instala e configura ZRAM
echo "💾 Instalando e configurando ZRAM..."
sudo apt install -y zram-tools
sudo systemctl enable zramswap
sudo systemctl start zramswap

# 6. Coloca atalhos na Área de Trabalho
echo "🖥️  Adicionando atalhos na Área de Trabalho..."
cp /usr/share/applications/google-chrome.desktop "$HOME/Desktop/" 2>/dev/null || true
cp /usr/share/applications/libreoffice-writer.desktop "$HOME/Desktop/" 2>/dev/null || true
cp /usr/share/applications/libreoffice-calc.desktop "$HOME/Desktop/" 2>/dev/null || true
cp /usr/share/applications/libreoffice-impress.desktop "$HOME/Desktop/" 2>/dev/null || true
cp /usr/share/applications/libreoffice-draw.desktop "$HOME/Desktop/" 2>/dev/null || true
chmod +x "$HOME/Desktop/"*.desktop 2>/dev/null || true

# 7. Troca Firefox por Chrome no painel (favoritos)
echo "📌 Substituindo Firefox pelo Chrome no painel..."

_atualizar_favoritos() {
    local key="$1"
    local current
    current=$(gsettings get "$key" 2>/dev/null) || return 1

    if [ "$current" = "@as []" ]; then
        gsettings set "$key" "['google-chrome.desktop']"
        echo "   ✅ Chrome adicionado em $key"
        return 0
    fi

    local sem_firefox
    sem_firefox=$(echo "$current" | sed "s/'firefox\.desktop'//g" \
        | sed 's/,,/,/g' | sed 's/\[, */[/' | sed 's/, *\]/]/' \
        | sed "s/^\[,* *\[/[/" | sed "s/,* *\]$/]/" | sed "s/^\[, */[/")

    local com_chrome
    if echo "$sem_firefox" | grep -q "google-chrome\.desktop"; then
        com_chrome="$sem_firefox"
    else
        com_chrome=$(echo "$sem_firefox" | sed "s/\[/['google-chrome.desktop', /" | sed "s/)$/)/")
    fi

    gsettings set "$key" "$com_chrome" 2>/dev/null && echo "   ✅ $key atualizado" || echo "   ⚠️  Falha ao atualizar $key"
}

_atualizar_favoritos "org.cinnamon.favorite-apps" || echo "   ⚠️  Não foi possível ler favorite-apps"
_atualizar_favoritos "org.cinnamon.panel-launchers" || true

# 8. Atualização geral do sistema
echo "⬆️ Atualizando todos os pacotes do sistema..."
sudo apt update -y
sudo apt upgrade -y

# 9. Limpeza Final
echo "🧹 Realizando limpeza do sistema..."
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean

# 10. Baixa o wallpaper e define como plano de fundo
echo "🖼️  Baixando e definindo wallpaper..."
mkdir -p "$HOME/Imagens/wallpaper"
wget https://raw.githubusercontent.com/lcsnaufal/lions-linux-apps/main/WallpaperLions.png -O "$HOME/Imagens/wallpaper/WallpaperLions.png" 2>/dev/null || true
gsettings set org.cinnamon.desktop.background picture-uri "file://$HOME/Imagens/wallpaper/WallpaperLions.png" 2>/dev/null || true
gsettings set org.cinnamon.desktop.background picture-uri-dark "file://$HOME/Imagens/wallpaper/WallpaperLions.png" 2>/dev/null || true

echo "========================================"
echo "✅ Configuração finalizada com sucesso!"
echo "🗑️  Este script irá se auto-excluir agora."
echo "========================================"

rm -- "$0"
