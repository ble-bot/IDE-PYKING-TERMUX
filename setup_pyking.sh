#!/data/data/com.termux/files/usr/bin/bash

# CONFIGURACIÓN DE SEGURIDAD
set -e  # Detener el script si ocurre un error

# COLORES
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

clear

# BANNER DE BIENVENIDA
echo -e "${CYAN}"
echo "  ██████╗ ██╗   ██╗██╗  ██╗██╗███╗   ██╗ ██████╗ "
echo "  ██╔══██╗╚██╗ ██╔╝██║ ██╔╝██║████╗  ██║██╔════╝ "
echo "  ██████╔╝ ╚████╔╝ █████╔╝ ██║██╔██╗ ██║██║  ███╗"
echo "  ██╔═══╝   ╚██╔╝  ██╔═██╗ ██║██║╚██╗██║██║   ██║"
echo "  ██║        ██║   ██║  ██╗██║██║ ╚████║╚██████╔╝"
echo "  ╚═╝        ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ "
echo -e "${BLUE}          -- EL IDE DEFINITIVO PARA PYTHON --${NC}"
echo ""

echo -e "${YELLOW}[!] Preparando el entorno de PyKing IDE...${NC}"
sleep 1

# FUNCIÓN PARA VERIFICAR PAQUETES
check_pkg() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${YELLOW}[!] Instalando $1...${NC}"
        pkg install -y "$1"
    fi
}

# 1. ACTUALIZACIÓN DE REPOSITORIOS
echo -e "\n${BLUE}[1/5] Actualizando repositorios de Termux...${NC}"
pkg update -y || echo -e "${RED}[!] Error al actualizar. Intentando continuar...${NC}"

# 2. INSTALACIÓN DE PAQUETES DEL SISTEMA
echo -e "\n${BLUE}[2/5] Instalando dependencias base (Python, Node, Neovim)...${NC}"
# Añadimos dependencias cruciales para plugins modernos de Neovim
pkg install -y python nodejs-lts neovim git build-essential clang binutils libexpat curl wget unzip

# 3. INSTALACIÓN DE HERRAMIENTAS DE DESARROLLO (PIP)
echo -e "\n${BLUE}[3/5] Instalando herramientas de Python (LSP, Linters)...${NC}"
echo -e "${YELLOW}Esto configurará Basedpyright y Ruff para autocompletado profesional.${NC}"

# Asegurar que pip esté actualizado
python -m pip install --upgrade pip --break-system-packages 2>/dev/null || true

# Instalación de herramientas clave
pip install basedpyright ruff debugpy pynvim --break-system-packages || \
pip install basedpyright ruff debugpy pynvim --user || \
echo -e "${RED}[!] Error en PIP. Algunos LSPs podrían no funcionar inmediatamente.${NC}"

# 4. DESPLEGANDO CONFIGURACIÓN DEL IDE
echo -e "\n${BLUE}[4/5] Desplegando configuración de PyKing...${NC}"

# Backup inteligente de configuración previa
if [ -d "$HOME/.config/nvim" ]; then
    BACKUP_DIR="$HOME/.config/nvim_backup_$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}[!] Se detectó una configuración previa. Moviendo a: $BACKUP_DIR${NC}"
    mv "$HOME/.config/nvim" "$BACKUP_DIR"
fi

mkdir -p "$HOME/.config/nvim"

# Copiar archivos desde el repositorio actual
if [ -d "nvim" ]; then
    cp -r nvim/* "$HOME/.config/nvim/"
    echo -e "${GREEN}[✔] Archivos de configuración instalados correctamente.${NC}"
else
    echo -e "${RED}[!] ERROR: No se encontró la carpeta 'nvim' en el directorio actual.${NC}"
    exit 1
fi

# 5. VERIFICACIÓN Y NOTAS FINALES
echo -e "\n${BLUE}[5/5] Resumen de la instalación...${NC}"
echo -n "Python: " && python --version || echo "No instalado"
echo -n "Neovim: " && nvim --version | head -n 1 || echo "No instalado"
echo -n "NodeJS: " && node --version || echo "No instalado"

echo -e "\n${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          INSTALACIÓN COMPLETADA CON ÉXITO            ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo -e "${CYAN}Próximos pasos:${NC}"
echo -e "1. Escribe ${YELLOW}nvim${NC} para iniciar el IDE."
echo -e "2. Los plugins se instalarán automáticamente en el primer inicio."
echo -e "3. Asegúrate de tener una ${CYAN}Nerd Font${NC} instalada en Termux para ver los iconos."
echo -e "\n${YELLOW}¡Disfruta programando con PyKing, @ble-bot!${NC}\n"
