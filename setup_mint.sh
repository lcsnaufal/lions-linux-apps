#!/bin/bash

# Interrompe o script se algum comando falhar
set -e

echo "========================================"
echo "🚀 Iniciando configuração do Linux Mint..."
echo "========================================"

# 1. Atualiza a lista de pacotes
echo "📦 Atualizando os repositórios..."
sudo apt update -y

# 2. Desinstala o Firefox (Versão APT e Versão Flatpak)
echo "🦊 Removendo o Firefox..."
# O "|| true" impede que o script pare se o Firefox já não estiver lá
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

# 5. Atualização geral do sistema
echo "⬆️ Atualizando todos os pacotes do sistema..."
sudo apt update -y
sudo apt upgrade -y

# 6. Manutenção e Limpeza Final
echo "🧹 Realizando limpeza do sistema..."
sudo apt autoremove -y  # Remove dependências órfãs geradas pelo purge e pelo upgrade
sudo apt autoclean -y    # Remove pacotes .deb desatualizados do cache
sudo apt clean           # Esvazia o cache inteiro

echo "========================================"
echo "✅ Configuração e atualização finalizadas com sucesso!"
echo "🗑️ Este script irá se auto-excluir agora."
echo "========================================"

# Comando para o script deletar a si mesmo
rm -- "$0"
