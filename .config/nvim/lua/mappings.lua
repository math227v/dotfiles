require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Tmux navigation mappings
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Navigate to left pane" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Navigate to right pane" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Navigate to bottom pane" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Navigate to upper pane" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
