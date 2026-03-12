#!/data/data/com.termux/files/usr/bin/bash

# COLORES
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

echo -e "${YELLOW}[!] Iniciando instalación de dependencias para PyKing...${NC}"
sleep 1

# 1. ACTUALIZACIÓN DE REPOSITORIOS
echo -e "\n${BLUE}[1/4] Actualizando sistema...${NC}"
pkg update -y && pkg upgrade -y

# 2. INSTALACIÓN DE PAQUETES DEL SISTEMA
echo -e "\n${BLUE}[2/4] Instalando herramientas base (Python, Node, Git, Build-Tools)...${NC}"
pkg install -y python nodejs neovim git build-essential clang binutils libexpat

# 3. INSTALACIÓN DE HERRAMIENTAS DE DESARROLLO (PIP)
echo -e "\n${BLUE}[3/4] Instalando Servidores de Lenguaje y Debuggers...${NC}"
echo -e "${YELLOW}Esto puede tardar un poco dependiendo de tu conexión...${NC}"

# Intentar instalación normal y con fallback
pip install --upgrade pip
pip install basedpyright ruff debugpy --break-system-packages || \
pip install basedpyright ruff debugpy --user || \
echo -e "${RED}[!] Error en PIP. Intentando vía PKG...${NC}" && pkg install -y pyright ruff

# 4. VERIFICACIÓN FINAL
echo -e "\n${BLUE}[4/4] Verificando instalación...${NC}"
echo -n "Python: " && python --version
echo -n "Neovim: " && nvim --version
echo -n "Ruff:   " && ruff --version

echo -e "\n${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          INSTALACIÓN COMPLETADA CON ÉXITO            ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo -e "${CYAN}Ya puedes abrir tu IDE escribiendo: ${YELLOW}nvim${NC}"
echo -e "${CYAN}¡Bienvenido a la comunidad de PyKing!${NC}\n"
