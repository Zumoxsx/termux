require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
-- Mapeo para abrir Telescope (buscador de archivos)
map({ "n", "i", "v" }, "<C-a>", "<cmd>Telescope find_files<cr>", { desc = "Telescope find files" })

-- Mapeo para alternar NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })

-- Mapeo para guardar con Ctrl+s en todos los modos
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- Mapeo para copiar al portapapeles del sistema
map("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })

-- Mapeo para salir con Ctrl+e en modos normal, inserción y visual
map({ "n", "i", "v" }, "<C-e>", "<cmd>q!<cr>", { desc = "Quit Neovim" })
