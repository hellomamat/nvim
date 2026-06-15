vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

vim.opt.updatetime = 500
vim.opt.timeoutlen = 400
vim.opt.pumheight = 15
vim.opt.maxmempattern = 5000
vim.opt.undolevels = 1000

vim.lsp.log.set_level("WARN")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({
				override = {},
				default = true,
				strict = true,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"html",
					"css",
					"json",
					"markdown",
					"tsx",
					"bash",
					"go",
					"rust",
					"dart",
					"vim",
					"regex",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				auto_install = true,
			})
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom",
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<M-l>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node",
				server_opts_overrides = {},
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"thesimonho/kanagawa-paper.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa-paper").setup({
				undercurl = true,
				transparent = false,
				gutter = false,
				diag_background = true,
				dim_inactive = false,
				terminal_colors = true,
				cache = false,
				styles = {
					comment = { italic = true },
					functions = { italic = false },
					keyword = { italic = false, bold = false },
					statement = { italic = false, bold = false },
					type = { italic = false },
				},
			})
			vim.cmd.colorscheme("kanagawa-paper-ink")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			require("nvim-tree").setup({
				respect_buf_cwd = false,
				sync_root_with_cwd = false,
				update_focused_file = {
					enable = false,
					update_cwd = false,
					update_root = false,
				},
				actions = {
					open_file = { quit_on_open = false },
					change_dir = {
						enable = false,
						global = false,
						restrict_above_cwd = false,
					},
					use_system_clipboard = true,
				},
				view = {
						float = {
							enable = true,
							open_win_config = {
								relative = "editor",
								border = "rounded",
								width = 35,
								height = 30,
								row = 1,
								col = 1,
							},
						},
					},
				renderer = {
					group_empty = true,
					highlight_git = false,
					icons = {
						show = { file = true, folder = true, folder_arrow = true, git = false },
					},
				},
				git = { enable = false },
				filters = { dotfiles = false },
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")
					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end
					api.config.mappings.default_on_attach(bufnr)
					vim.keymap.set("n", "o", api.node.open.edit, opts("Open without changing root"))
					vim.keymap.set("n", "O", api.node.open.vertical, opts("Open vertical without changing root"))
					vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("Change root to current node"))
					vim.keymap.set("n", "|", api.node.open.vertical, opts("Open in vertical split"))
					vim.keymap.set("n", "-", api.node.open.horizontal, opts("Open in horizontal split"))
				end,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					section_separators = "",
					component_separators = "",
					globalstatus = true,
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						"%.git/",
						"dist",
						"build",
						"target",
						"vendor",
						".next",
						".nuxt",
						"coverage",
					},
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.45,
							height = 0.8,
						},
					},
					sorting_strategy = "ascending",
					winblend = 10,
					preview = {
						filesize_limit = 0.5,
						timeout = 250,
					},
				},
				pickers = {
					find_files = { theme = "dropdown", previewer = false },
					buffers = { theme = "dropdown", previewer = false },
					live_grep = { theme = "dropdown" },
				},
			})
			pcall(telescope.load_extension, "fzf")
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			cmdline = { view = "cmdline_popup" },
			messages = { enabled = true, view = "mini" },
			notify = { enabled = true, view = "mini" },
			views = {
				mini = {
					backend = "popup",
					relative = "editor",
					align = "message-right",
					position = { row = -1, col = "50%" },
					size = { width = "auto", height = "auto" },
					border = { style = "rounded" },
					win_options = {
						winblend = 10,
						winhighlight = {
							Normal = "Normal",
							FloatBorder = "NoiceMiniBorder",
						},
					},
				},
				cmdline_popup = {
					position = { row = 2, col = "50%" },
					size = { width = 60, height = "auto" },
				},
			},
		},
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				PATH = "skip",
				ui = { check_outdated_packages_on_open = false },
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"rust_analyzer",
					"lua_ls",
					"svelte",
					"cssls",
					"html",
					"jsonls",
					"gopls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
				if client.name == "dartls" then
					client.server_capabilities.documentFormattingProvider = true
					client.server_capabilities.documentRangeFormattingProvider = true
				else
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			end

			vim.lsp.config("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("rust_analyzer", {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				root_markers = { "Cargo.toml", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("lua_ls", {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true) },
					},
				},
			})

			vim.lsp.config("gopls", {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("dartls", {
				cmd = { "dart", "language-server", "--protocol=lsp" },
				filetypes = { "dart" },
				root_markers = { "pubspec.yaml" },
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					client.server_capabilities.semanticTokensProvider = nil
					client.server_capabilities.documentFormattingProvider = false
				end,
				settings = {
					dart = {
						analysisExcludedFolders = {
							vim.fn.expand("$HOME/.pub-cache"),
							vim.fn.expand("$HOME/.flutter"),
							"build",
						},
						completeFunctionCalls = true,
						showTodos = false,
					},
				},
			})

			vim.lsp.config("cssls", {
				cmd = { "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
				root_markers = { "package.json", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("html", {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html" },
				root_markers = { "package.json", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("jsonls", {
				cmd = { "vscode-json-language-server", "--stdio" },
				filetypes = { "json", "jsonc" },
				root_markers = { "package.json", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.config("svelte", {
				cmd = { "svelteserver", "--stdio" },
				filetypes = { "svelte" },
				root_markers = { "package.json", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.lsp.enable("ts_ls")
			vim.lsp.enable("rust_analyzer")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("gopls")
			vim.lsp.enable("dartls")
			vim.lsp.enable("cssls")
			vim.lsp.enable("html")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("svelte")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"zbirenbaum/copilot-cmp",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "copilot", group_index = 2 },
					{ name = "nvim_lsp", group_index = 2 },
					{ name = "luasnip", group_index = 2 },
					{ name = "buffer", group_index = 2 },
					{ name = "path", group_index = 2 },
				}),
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					lua = { "stylua" },
					rust = { "rustfmt" },
					go = { "gofmt" },
				},
				format_on_save = false,
			})

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({
					timeout_ms = 3000,
					lsp_fallback = true,
					range = range,
				})
			end, { range = true })
		end,
	},
	{ "numToStr/Comment.nvim", opts = {} },
	{ "lewis6991/gitsigns.nvim", config = true },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup()
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "tabs",
					diagnostics = "nvim_lsp",
					separator_style = "slant",
					show_buffer_close_icons = false,
					show_close_icon = false,
					offsets = {},
				},
			})
		end,
	},
	{ "rust-lang/rust.vim", ft = { "rust" } },
	{ "fatih/vim-go", ft = { "go" } },
	{ "dart-lang/dart-vim-plugin", ft = { "dart" } },
	{ "leafgarland/typescript-vim", ft = { "typescript", "typescriptreact", "javascriptreact" } },
	{ "pangloss/vim-javascript", ft = { "javascript", "javascriptreact" } },
	{ "yuezk/vim-js", ft = { "javascript", "javascriptreact" } },
	{ "maxmellon/vim-jsx-pretty", ft = { "javascriptreact", "typescriptreact" } },
	{ "mg979/vim-visual-multi" },
	{ "stevearc/dressing.nvim" },
	{ "catppuccin/nvim", name = "catppuccin" },
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.python3_host_prog = ""
vim.g.node_host_prog = ""
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.colorcolumn = "100"
vim.opt.mouse = ""

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<Up>", "", opts)
map("n", "<Down>", "", opts)
map("n", "<Left>", "", opts)
map("n", "<Right>", "", opts)
map("i", "<Up>", "", opts)
map("i", "<Down>", "", opts)
map("i", "<Left>", "", opts)
map("i", "<Right>", "", opts)

local term_counter = 0

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(args)
		term_counter = term_counter + 1
		local label = "term-" .. term_counter
		local buf = args.buf
		vim.defer_fn(function()
			pcall(vim.api.nvim_buf_call, buf, function()
				vim.cmd("file " .. label)
			end)
		end, 100)
	end,
})

local function new_terminal(split_cmd)
	if split_cmd then vim.cmd(split_cmd) end
	vim.cmd("terminal")
	vim.cmd("startinsert")
end

local function OpenRightTerminals()
	vim.cmd("vsplit")
	vim.cmd("wincmd L")
	new_terminal()
	vim.cmd("belowright split")
	new_terminal()
end

map("n", "q", "<Esc>", opts)
map("v", "q", "<Esc>", opts)

map("n", "<leader>lh", function()
	local ok, lazy = pcall(require, "lazy")
	if not ok then
		vim.notify("❌ Lazy.nvim belum dimuat!", vim.log.levels.ERROR)
		return
	end

	local stats = lazy.stats()
	if not stats or not stats.plugins then
		vim.notify("⚠️ Tidak ada data profil plugin yang tersedia", vim.log.levels.WARN)
		return
	end

	local sorted = {}
	for name, data in pairs(stats.plugins) do
		table.insert(sorted, { name = name, time = data.time or 0 })
	end
	table.sort(sorted, function(a, b)
		return a.time > b.time
	end)

	local msg = "🔥 Plugin paling berat (Top 10)\n\n"
	for i = 1, math.min(10, #sorted) do
		local p = sorted[i]
		msg = msg .. string.format("%2d. %-25s ⏱ %.2f ms\n", i, p.name, p.time)
	end

	vim.notify(msg, vim.log.levels.INFO, { title = "Lazy.nvim Profiling" })
end, { desc = "Tampilkan plugin paling berat di Lazy.nvim" })

map("n", "<leader>cp", ":Copilot panel<CR>", opts)
map("n", "<leader>cs", ":Copilot status<CR>", opts)
map("n", "<leader>ce", ":Copilot enable<CR>", opts)
map("n", "<leader>cd", ":Copilot disable<CR>", opts)

map("n", "<leader>ttt", OpenRightTerminals, opts)
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
map("n", "<Space>E", vim.diagnostic.open_float, opts)
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>qq", ":qa!<CR>", opts)
map("n", "<leader>t", ":tabnew<CR>", opts)
map("n", "<leader>m", ":MemoryCheck<CR>", opts)
map("n", "<leader>c", ":CleanMem<CR>", opts)
map("n", "<leader>n", ":tabnext<CR>", opts)
map("n", "<leader>p", ":tabprev<CR>", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-=>", ":vertical resize +10<CR>", opts)
map("n", "<C-->", ":vertical resize -10<CR>", opts)
map("n", "<M-l>", ":vertical resize -10<CR>", opts)
map("n", "<M-h>", ":vertical resize +10<CR>", opts)
map("n", "<leader>tt", function() new_terminal("vsplit | wincmd L") end, opts)
map("n", "<leader>tT", function() new_terminal("split | wincmd J") end, opts)
map("t", "<Esc><Esc>", [[<C-\><C-n>]], opts)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
map("n", "<Space>0", ":BufferLineCycleNext<CR>", opts)
map("n", "<Space>9", ":BufferLineCyclePrev<CR>", opts)
map("n", "<leader>3", ":bd<CR>", opts)
map("n", "<Space>f", ":Format<CR>", opts)
map("v", "<Space>f", ":Format<CR>", opts)

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "dart",
-- 	callback = function()
-- 		vim.keymap.set("n", "<Space>f", function()
-- 			vim.lsp.buf.format({ async = false })
-- 		end, { buffer = true, noremap = true, silent = true })
-- 	end,
-- })

map("i", "<Space>n", function()
	require("cmp").complete()
end, { noremap = true, silent = true, expr = false, desc = "Trigger completion menu" })
map("n", "<leader>ai", function()
	require("ai").chat()
end, { noremap = true, silent = true, desc = "Chat with GPT" })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Disable format untuk LSP (gunakan conform.nvim saja)
capabilities.textDocument.formatting = false
capabilities.textDocument.rangeFormatting = false

local configured_servers = {}

-- =========================
-- === Autocomplete ===
-- =========================
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			select = true,
		}),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
		{
			name = "copilot",
			group_index = 2,
		},
		{
			name = "nvim_lsp",
			group_index = 2,
		},
		{
			name = "buffer",
			group_index = 2,
		},
		{
			name = "luasnip",
			group_index = 2,
		},
	}),
})

-- =========================
-- === Mason & LSP (MEMORY LEAK FIXED!) ===
-- =========================
require("mason").setup({
	PATH = "skip",
	ui = { check_outdated_packages_on_open = false },
})
require("mason-lspconfig").setup({
	ensure_installed = { "ts_ls", "rust_analyzer", "lua_ls", "svelte", "cssls" },
	automatic_installation = true,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Disable format untuk LSP (gunakan conform.nvim saja)
capabilities.textDocument.formatting = false
capabilities.textDocument.rangeFormatting = false

local configured_servers = {}
