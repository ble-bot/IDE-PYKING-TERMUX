local vim = vim

-- 1. AGREGAR MASON AL PATH
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH

-- 2. BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3. CONFIGURACIÓN GENERAL
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.updatetime = 100 -- RECORTE DE TIEMPO: De 250ms a 100ms para respuesta instantánea
vim.opt.cursorline = true

-- 4. PLUGINS (lazy.nvim)
require("lazy").setup({
    -- Estética
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
    {
        'goolord/alpha-nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            local alpha = require'alpha'
            local dashboard = require'alpha.themes.dashboard'
            dashboard.section.header.val = {
                [[          .77777777777777$.           ]],
                [[          777..777777777777$+       ]],
                [[         .77 7777777777$$$          ]],
                [[         .777 .7777777777$$$$       ]],
                [[         .7777777777777$$$$$$       ]],
                [[         ..........:77$$$$$$$       ]],
                [[  .7777777777777777$$$$$$$$$$.=======.  ]],
                [[77777777777777777$$$$$$$$$$$.========   ]],
                [[777777777777777$$$$$$$$$$$$$$.=========  ]],
                [[77777777777$$$$$$$$$$$$$$$$$$ :========+. ]],
                [[77777777777$$$$$$$$$$$$$$$$+..=========++~]],
                [[777777777$$..~======================+++++]],
                [[77777777$~.~~~~=~==================+++++. ]],
                [[777777$$$.~~~====================++++++++.]],
                [[777777$$$$.~~===================++++++++: ]],
                [[7$$$$$$$.====================++++++++++.  ]],
                [[.,$$$$$$.=================++++++++++~.    ]],
                [[         .=========~.........       ]],
                [[         .==============++++++      ]],
                [[         .===========+++..+++       ]],
                [[         .==========+++. .++        ]],
                [[          ,=======++++++,,++,       ]],
                [[          ..=====+++++++++=.        ]],
                [[                ..~+=...            ]],
                [[                                    ]],
                [[      -- == [ P Y K I N G ] == --      ]],
            }
            dashboard.section.buttons.val = {
                dashboard.button("n", "  Nuevo Script Python", ":lua _G.pyking_new_python()<CR>"),
                dashboard.button("f", "  Buscar Proyectos", ":Telescope find_files<CR>"),
                dashboard.button("l", "  Plugins de PyKing", ":Lazy<CR>"),
                dashboard.button("m", "  LSPs (Pyright/Ruff)", ":Mason<CR>"),
                dashboard.button("i", "  Comandos PIP (Instalación)", ":lua _G.pyking_show_pip_commands()<CR>"),
                dashboard.button("p", "  Terminal (PIP / RUN)", ":ToggleTerm<CR>"),
                dashboard.button("q", "  Salir de PyKing", ":qa<CR>"),
            }
            alpha.setup(dashboard.opts)
        end
    },
    
    -- Navegación
    { 
        "preservim/nerdtree", 
        dependencies = { 
            "ryanoasis/vim-devicons",
            "Xuyuanp/nerdtree-git-plugin",
        },
        config = function()
            vim.g.NERDTreeShowHidden = 1
            vim.g.NERDTreeMinimalUI = 1
            vim.g.NERDTreeDirArrowExpandable = ''
            vim.g.NERDTreeDirArrowCollapsible = ''
            vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1
        end
    },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    
    -- IDE Python: LSP & Mason
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    
    -- IDE Python: Formateo y Documentación
    { "stevearc/conform.nvim", config = true },
    { "danymat/neogen", config = true },
    
    -- IDE Python: Debugger (DAP)
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
    { "mfussenegger/nvim-dap-python" },

    -- Autocompletado
    { "hrsh7th/nvim-cmp", dependencies = { 
        "hrsh7th/cmp-nvim-lsp", 
        "hrsh7th/cmp-buffer", 
        "hrsh7th/cmp-path", 
        "L3MON4D3/LuaSnip", 
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim",
        "hrsh7th/cmp-nvim-lsp-signature-help"
    } },

    -- Herramientas
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
    { "akinsho/toggleterm.nvim", version = "*", config = true },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        config = function()
            require("tiny-inline-diagnostic").setup({
                preset = "modern",
                options = {
                    show_source = true,
                    use_icons_from_diagnostic = true,
                    add_border = true,
                }
            })
        end
    },
})

-- 5. CONFIGURACIÓN DE DIAGNÓSTICOS
vim.diagnostic.config({
    virtual_text = {
        prefix = '●', 
        source = "if_many",
    },
    signs = true,
    underline = true,
    update_in_insert = true, -- ¡TIEMPO REAL ABSOLUTO!
    severity_sort = true,
    float = {
        border = "rounded",
        source = "always",
    },
})

-- Reducir el lag del servidor LSP (Configuración avanzada)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
    }
)

-- 6. TEMA CATPPUCCIN
local cp_status, catppuccin = pcall(require, "catppuccin")
if cp_status then
    catppuccin.setup({
        flavour = "mocha",
        integrations = { dap = true, treesitter = true, native_lsp = { enabled = true } },
    })
    vim.cmd.colorscheme "catppuccin"
end

-- 7. LUALINE & BUFFERLINE (Corregido)
local ll_status, lualine = pcall(require, "lualine")
if ll_status then
    lualine.setup({ options = { theme = 'catppuccin', section_separators = { left = '', right = '' } } })
end

local bl_status, bufferline = pcall(require, "bufferline")
if bl_status then
    bufferline.setup({ options = { separator_style = "slant", diagnostics = "nvim_lsp" } })
end

-- 8. TREESITTER (Corregido)
local ts_status, ts_configs = pcall(require, "nvim-treesitter.configs")
if ts_status then
    ts_configs.setup({
        ensure_installed = { "python", "lua" },
        highlight = { enable = true },
    })
end

-- 9. CONFIGURACIÓN LSP (Baspyright & Ruff del Sistema)
-- Silenciar aviso de obsolescencia de lspconfig en nvim 0.11+
vim.g.lspconfig_silent_deprecation = true

require("mason").setup()
require("mason-lspconfig").setup({ 
    ensure_installed = {} -- Dejamos vacío para que no falle en Termux
})

local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if lspconfig_status then
    local cmp_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = cmp_lsp_status and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
    
    -- Lua (Usando el del sistema / PKG)
    lspconfig.lua_ls.setup({
        cmd = { "lua-language-server" },
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = { globals = { 'vim' } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    })
    
    -- Lógica de Servidor de Lenguaje (Súper Inteligente - Configuración Optimizada)
    local pyking_on_attach = function(client, bufnr)
        -- Activar Inlay Hints (Tipos y parámetros visuales)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end

    if vim.fn.executable("basedpyright-langserver") == 1 then
        lspconfig.basedpyright.setup({ 
            cmd = { "basedpyright-langserver", "--stdio" },
            capabilities = capabilities,
            on_attach = pyking_on_attach,
            settings = { 
                basedpyright = { 
                    analysis = { 
                        typeCheckingMode = "standard", -- Más inteligente que "basic"
                        autoImportCompletions = true,
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                        -- "Cerebro" del IDE: Filtramos lo molesto pero dejamos lo importante
                        diagnosticSeverityOverrides = {
                            reportOptionalMemberAccess = "none",
                            reportOptionalSubscript = "none",
                            reportOptionalCall = "none",
                            reportAttributeAccessIssue = "none",
                            reportGeneralTypeIssues = "none",
                            reportAny = "none",
                            reportArgumentType = "none", -- Soluciona el error de urljoin
                            reportCallIssue = "none",    -- Evita errores al llamar funciones dinámicas
                            reportIndexIssue = "none",   -- Evita errores con ["href"] o similares
                            reportUnknownMemberAccess = "none",
                            reportUnknownVariableType = "none",
                            reportUnknownArgumentType = "none",
                        },
                    },
                },
            },
            -- ACTIVAR INLAY HINTS (La magia visual)
            on_attach = function(client, bufnr)
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
            end,
        })
    elseif vim.fn.executable("pyright-langserver") == 1 then
        lspconfig.pyright.setup({ 
            cmd = { "pyright-langserver", "--stdio" },
            capabilities = capabilities,
            on_attach = pyking_on_attach,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                    },
                },
            },
        })
    end
    
    -- Ruff (Usando el del sistema)
    lspconfig.ruff.setup({ 
        cmd = { "ruff", "server" }, -- Forzamos el comando del sistema
        capabilities = capabilities,
    })
end

-- 10. AUTO-FORMATEO AL GUARDAR
local conform_status, conform = pcall(require, "conform")
if conform_status then
    conform.setup({
        formatters_by_ft = { python = { "ruff_format" } },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
    })
end

-- 11. DEBUGGER (DAP)
local d_status, dap = pcall(require, "dap")
local du_status, dapui = pcall(require, "dapui")
local dp_status, dap_python = pcall(require, "dap-python")

if d_status and du_status and dp_status then
    dapui.setup()
    dap_python.setup('python3')
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
end

-- 12. AUTOCOMPLETADO (Configuración Optimizada)
local c_status, cmp = pcall(require, "cmp")
if c_status then
    local l_status, luasnip = pcall(require, "luasnip")
    local lk_status, lspkind = pcall(require, "lspkind")
    
    cmp.setup({
        snippet = { expand = function(args) if l_status then luasnip.lsp_expand(args.body) end end },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        -- PRE-SELECCIÓN: Esto hace que la primera opción siempre esté lista para ENTER
        preselect = cmp.PreselectMode.Item,
        formatting = {
            format = lk_status and lspkind.cmp_format({
                mode = 'symbol_text',
                preset = 'codicons', -- ESTOS SÍ TE FUNCIONABAN
                maxwidth = 50,
                ellipsis_char = '...',
                symbol_map = {
                    Text = "", Method = "", Function = "", Constructor = "",
                    Field = "", Variable = "", Class = "", Interface = "",
                    Module = "", Property = "", Unit = "", Value = "",
                    Enum = "", Keyword = "", Snippet = "", Color = "",
                    File = "", Reference = "", Folder = "", EnumMember = "",
                    Constant = "", Struct = "", Event = "", Operator = "",
                    TypeParameter = "",
                },
            }) or nil,
        },
        mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- ENTER confirma la primera opción
            ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp', priority = 1000 },
            { name = 'nvim_lsp_signature_help', priority = 800 },
            { name = 'luasnip', priority = 750 },
            { name = 'buffer', priority = 500 },
            { name = 'path', priority = 250 },
        }),
        completion = {
            keyword_length = 1,
            completeopt = 'menu,menuone,noinsert',
        },
        experimental = {
            ghost_text = true,
        }
    })

    -- INTEGRACIÓN DE AUTOPAIRS: Definitivo para Paréntesis
    local cmp_autopairs_status, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if cmp_autopairs_status then
        -- Añade paréntesis automáticamente tras ENTER o TAB en funciones
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({
            map_char = { tex = "" }
        }))
    end
end

-- 13. FUNCIONES ESPECIALES (PYKING)
function _G.pyking_new_python()
    vim.cmd("enew")
    vim.bo.filetype = "python"
    vim.b.pyking_unnamed = true
    vim.notify("PyKing: Nuevo script listo. Escribe tu código y usa <leader>w para guardar.", "info")
end

function _G.pyking_show_pip_commands()
    local buf = vim.api.nvim_create_buf(false, true)
    
    local function render(page)
        local lines = {}
        if page == 1 then
            lines = {
                " ╔══════════════════════════════════════════════════════╗",
                " ║ [1] HERRAMIENTAS CORE (LSP, LINTER, DEBUG)           ║",
                " ╚══════════════════════════════════════════════════════╝",
                " Si el comando normal falla, prueba con las alternativas:",
                "",
                " 1. Basedpyright (LSP Principal):",
                "    - pip install basedpyright",
                "    - pip install basedpyright --break-system-packages",
                "    - pkg install pyright (Alternativa estable)",
                "",
                " 2. Ruff (Linter & Formatter):",
                "    - pip install ruff",
                "    - pkg install ruff",
                "",
                " 3. Debugpy (Debugger):",
                "    - pip install debugpy",
                "",
                " 💡 TIP: Usa '--force-reinstall' si tienes paquetes corruptos.",
                " ────────────────────────────────────────────────────────",
                " [2] Ver Frameworks | [q] Cerrar",
            }
        else
            lines = {
                " ╔══════════════════════════════════════════════════════╗",
                " ║ [2] FRAMEWORKS Y PAQUETES COMUNES (TERMUX)           ║",
                " ╚══════════════════════════════════════════════════════╝",
                " Comandos recomendados para desarrollo web y datos:",
                "",
                " 🌐 Desarrollo Web:",
                "    - pip install flask django fastapi uvicorn",
                "",
                " 📊 Datos (Mejor usar PKG en Termux para evitar errores):",
                "    - pkg install python-numpy python-pandas",
                "    - pip install requests pillow sqlalchemy",
                "",
                " 🛠️  Recomendación General:",
                "    Antes de instalar cosas pesadas, ejecuta:",
                "    pkg install build-essential python-pip",
                "",
                " ────────────────────────────────────────────────────────",
                " [1] Ver Core Tools | [q] Cerrar",
            }
        end
        vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
    end

    render(1)
    vim.api.nvim_buf_set_keymap(buf, 'n', '1', '', { callback = function() render(1) end })
    vim.api.nvim_buf_set_keymap(buf, 'n', '2', '', { callback = function() render(2) end })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
    
    local width = 60
    local height = 22
    local ui = vim.api.nvim_list_uis()[1]
    vim.api.nvim_open_win(buf, true, {
        relative = 'editor', width = width, height = height,
        col = (ui.width - width) / 2, row = (ui.height - height) / 2,
        style = 'minimal', border = 'rounded'
    })
end

function _G.pyking_save()
    if vim.b.pyking_unnamed and vim.fn.expand('%') == "" then
        local name = vim.fn.input("Nombre del archivo (NO pongas .py, se pondrá solo): ")
        if name == "" then 
            vim.notify("Guardado cancelado", "warn")
            return 
        end
        -- Quitar .py si el usuario lo puso por error y luego añadirlo siempre
        name = name:gsub("%.py$", "") .. ".py"
        vim.cmd("write " .. name)
        vim.b.pyking_unnamed = false
        vim.notify("Archivo guardado como " .. name, "info")
    else
        vim.cmd("w")
    end
end

-- 14. ATAJOS DE TECLADO (ESPACIO COMO LIDER)
local opts = { noremap = true, silent = true }

-- Guardar, Salir, y Guardar/Salir
vim.keymap.set('n', '<leader>w', function() _G.pyking_save() end, opts) -- Espacio + w (Guardar Inteligente)
vim.keymap.set('n', '<leader>q', ':q!<CR>', opts) -- Espacio + q (Salir forzado)
vim.keymap.set('n', '<leader>x', ':x<CR>', opts) -- Espacio + x (Guardar y Salir)

-- Otros atajos útiles existentes
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>', opts)
vim.keymap.set('n', '<Right>', ':bnext<CR>', opts)
vim.keymap.set('n', '<Left>', ':bprev<CR>', opts)
vim.keymap.set('n', '<leader>r', ':TermExec cmd="python3 %" direction=float<CR>', opts)
vim.keymap.set('n', '<leader>b', function() if d_status then dap.toggle_breakpoint() end end, opts)
vim.keymap.set('n', '<leader>c', function() if d_status then dap.continue() end end, opts)
vim.keymap.set('n', '<leader>d', ":Neogen<CR>", opts)
vim.keymap.set('n', '<leader>p', ":Telescope find_files<CR>", opts)
