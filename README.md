# 🐍 IDE-PYKING-TERMUX

¡Bienvenido al IDE definitivo para Python en Termux! PyKing es una configuración profesional para Neovim diseñada para que los desarrolladores de Python tengan una experiencia fluida, rápida y potente en dispositivos móviles y sistemas Linux ligeros.

## 🚀 Características ÚNICAS

### 1. **Smart Save (Guardado Inteligente)**
Se acabó el crear archivos sin extensión. Al pulsar `Space + w` en un archivo nuevo:
- Te pide el nombre en la parte inferior.
- **Añade automáticamente el `.py`** si te olvidas.
- Evita errores del IDE al marcar el archivo como Python desde el segundo 1.

### 2. **LSP Fallback System (Autocompletado Robusto)**
El IDE detecta tus herramientas instaladas:
- Prioriza `Basedpyright` (la versión más moderna y estable).
- Si no está, usa automáticamente `Pyright` como respaldo.
- **Nunca te quedarás sin autocompletado ni detección de errores.**

### 3. **Ventana Interactiva de Instalación**
Pulsa **`i`** en el menú de inicio para abrir la guía interactiva:
- **Página 1:** Comandos para instalar LSPs, Linters (Ruff) y Debuggers (DAP) con métodos de escape para Termux.
- **Página 2:** Recomendaciones de Frameworks (Flask, Django, Pandas) optimizados para Android.

### 4. **Estética Profesional**
- Iconos en archivos y carpetas (`NerdTree`).
- Integración nativa con Git.
- Mensajes de error en tiempo real (Virtual Text).
- Paréntesis automáticos al elegir funciones (`print()`).

---

## 🛠️ Instalación Rápida (Recomendado)

Solo tienes que ejecutar este comando en tu Termux:

```bash
bash setup_pyking.sh
```

El script se encargará de instalar Python, Node, Neovim, Git, compiladores y todas las herramientas de Python necesarias.

---

## ⌨️ Atajos de Teclado (Líder: ESPACIO)

| Tecla | Acción |
|---|---|
| `<leader>w` | Guardar (Inteligente) |
| `<leader>q` | Salir forzado |
| `<leader>r` | **EJECUTAR Script Python** (Terminal flotante) |
| `<C-n>` | Abrir/Cerrar Explorador de Archivos |
| `<leader>b` | Poner Breakpoint (Debugger) |
| `<leader>c` | Continuar Debugging |
| `<leader>d` | Generar Documentación Python |
| `<leader>p` | Buscar archivos (Telescope) |

---

## 🤝 Comunidad

Este es un IDE para la comunidad de Python. Si tienes ideas o mejoras, ¡abre un Issue o haz un Pull Request!

**¡Disfruta programando con PyKing!**
