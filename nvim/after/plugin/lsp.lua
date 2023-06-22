local lsp = require("lsp-zero").preset({})
local cmp = require("cmp")

cmp.setup({
	mapping = {
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	},
})

lsp.ensure_installed({
	"lua_ls",
	"tsserver",
})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({
		buffer = bufnr,
		omit = { "K" },
	})
	vim.keymap.set({ "n", "x" }, "gq", function()
		vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
	end)
end)

lsp.setup()

require("null-ls").setup({})

require("mason-null-ls").setup({
	automatic_installation = false,
	handlers = {},
})

require("lspsaga").setup({
	ui = {
		kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
	},
	lightbulb = {
		virtual_text = true,
	},
})

local keymap = vim.keymap.set
keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>")
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

