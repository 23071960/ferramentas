#!/bin/bash
# Script para criar usuario Escola com privilegios de leitura e escrita
# Sistema: Linux Mint XFCE
# Executar como: sudo ./criar_usuario_escola.sh

# ============================================
# CONFIGURACOES
# ============================================
USERNAME="escola"
PASSWORD="escola"
FULLNAME="Escola"

# ============================================
# VERIFICACAO DE ROOT
# ============================================
if [ "$EUID" -ne 0 ]; then
    echo "Erro: Este script precisa ser executado como root (sudo)."
    echo "Uso: sudo ./criar_usuario_escola.sh"
    exit 1
fi

echo "=========================================="
echo "  Criando usuario: $USERNAME"
echo "=========================================="

# ============================================
# VERIFICAR SE O USUARIO JA EXISTE
# ============================================
if id "$USERNAME" &>/dev/null; then
    echo "Aviso: O usuario '$USERNAME' ja existe."
    read -p "Deseja remover o usuario existente e recriar? (s/N): " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        echo "Removendo usuario existente..."
        userdel -r "$USERNAME" 2>/dev/null
    else
        echo "Operacao cancelada."
        exit 0
    fi
fi

# ============================================
# CRIAR O USUARIO
# ============================================
echo "[1/5] Criando usuario..."
useradd -m -c "$FULLNAME" -s /bin/bash "$USERNAME"

if [ $? -ne 0 ]; then
    echo "Erro: Falha ao criar o usuario."
    exit 1
fi

# ============================================
# DEFINIR SENHA
# ============================================
echo "[2/5] Definindo senha..."
echo "$USERNAME:$PASSWORD" | chpasswd

if [ $? -ne 0 ]; then
    echo "Erro: Falha ao definir a senha."
    exit 1
fi

# ============================================
# CONFIGURAR GRUPOS E PERMISSOES
# ============================================
echo "[3/5] Configurando grupos e permissoes..."

# Adicionar ao grupo 'users' para permissao de leitura/escrita em diretorios comuns
usermod -aG users "$USERNAME"

# Adicionar ao grupo 'lp' para impressoras
usermod -aG lp "$USERNAME"

# Adicionar ao grupo 'scanner' se existir (para scanners)
if getent group scanner >/dev/null; then
    usermod -aG scanner "$USERNAME"
fi

# Adicionar ao grupo 'cdrom' para acesso a midias
usermod -aG cdrom "$USERNAME"

# Adicionar ao grupo 'plugdev' para dispositivos USB
usermod -aG plugdev "$USERNAME"

# ============================================
# CONFIGURAR PERMISSOES DO DIRETORIO HOME
# ============================================
echo "[4/5] Configurando diretorio home..."

# Garantir que o usuario tenha controle total do proprio diretorio home
chown -R "$USERNAME:$USERNAME" "/home/$USERNAME"
chmod 755 "/home/$USERNAME"

# ============================================
# CONFIGURAR AMBIENTE XFCE
# ============================================
echo "[5/5] Configurando ambiente XFCE..."

# Criar diretorio de configuracao XFCE se necessario
mkdir -p "/home/$USERNAME/.config/xfce4"
chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.config"

# ============================================
# INFORMACOES FINAIS
# ============================================
echo ""
echo "=========================================="
echo "  USUARIO CRIADO COM SUCESSO!"
echo "=========================================="
echo ""
echo "Informacoes do usuario:"
echo "  - Nome:     $USERNAME"
echo "  - Senha:    $PASSWORD"
echo "  - Home:     /home/$USERNAME"
echo "  - Shell:    /bin/bash"
echo "  - Grupos:   $(id -Gn $USERNAME)"
echo ""
echo "Permissoes configuradas:"
echo "  - Leitura e escrita no diretorio home"
echo "  - Acesso a dispositivos USB (plugdev)"
echo "  - Acesso a midias (cdrom)"
echo "  - Acesso a impressoras (lp)"
echo "  - Acesso a scanners (se disponivel)"
echo ""
echo "Para fazer login, use:"
echo "  - Usuario: $USERNAME"
echo "  - Senha:   $PASSWORD"
echo ""
echo "=========================================="
