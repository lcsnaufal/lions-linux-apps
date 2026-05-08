# 🚀 Linux Mint Post-Install Setup

Este repositório contém um script de pós-instalação para o Linux Mint. Ele foi criado para automatizar a configuração inicial do sistema, economizando tempo ao formatar ou configurar uma máquina nova.

O script realiza as atualizações necessárias, troca o navegador padrão, instala pacotes essenciais de produtividade e, ao final, faz uma limpeza profunda e exclui a si mesmo para manter o sistema impecável.

## ⚙️ O que o script faz?

Quando executado, o script segue automaticamente este fluxo:

1. **Atualiza os repositórios** (`apt update`).
2. **Remove o Mozilla Firefox** (e todos os seus arquivos de configuração e dependências).
3. **Baixa e instala o Google Chrome** (versão estável mais recente oficial do Google).
4. **Instala o LibreOffice** (já com o pacote de tradução `pt-BR`).
5. **Atualiza todo o sistema** (`apt upgrade`).
6. **Limpeza profunda** (`autoremove`, `autoclean`, `clean`), removendo resquícios de pacotes antigos e do Firefox.
7. **Auto-exclusão:** O arquivo do script é deletado automaticamente do seu computador ao final do processo.

---

## 💻 Como rodar o script

Abra o seu terminal (`Ctrl + Alt + T`), copie o comando único abaixo, cole e aperte **Enter**:

```bash
wget [https://raw.githubusercontent.com/lcsnaufal/lions-linux-apps/main/setup_mint.sh](https://raw.githubusercontent.com/lcsnaufal/lions-linux-apps/main/setup_mint.sh) && chmod +x setup_mint.sh && ./setup_mint.sh
