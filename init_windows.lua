vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cmdheight = 2
vim.opt.updatetime = 500
vim.opt.timeoutlen = 400
vim.opt.pumheight = 15
vim.opt.maxmempattern = 5000
vim.opt.undolevels = 1000

-- Git Bash sebagai shell
vim.opt.shell = "bash"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

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
				color_icons = false,
				override_by_extension = {
					["default_icon"] = { icon = "-", color = "#6d8086", name = "Default" },
				},
			})
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
						show = { file = false, folder = true, folder_arrow = true, git = false },
						glyphs = {
							default = "-",
							symlink = "~",
							folder = {
								arrow_closed = ">",
								arrow_open = "v",
								default = "+",
								open = "-",
								empty = "o",
								empty_open = "o",
								symlink = "~",
								symlink_open = "~",
							},
						},
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
					icons_enabled = false,
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
					vimgrep_arguments = {
						"C:\\Program Files\\Git\\usr\\bin\\grep.exe",
						"--color=never",
						"--with-filename",
						"--line-number",
						"--recursive",
						"--ignore-case",
						"--binary-files=without-match",
					},
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
				PATH = "prepend", -- prepend biar .cmd Windows resolve otomatis
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
					"lua_ls",
					"svelte",
					"cssls",
					"html",
					"jsonls",
					"gopls",
					"jdtls",
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
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

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
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("gopls")
			vim.lsp.enable("cssls")
			vim.lsp.enable("html")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("svelte")
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		config = function()
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
			local launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
			local workspace = vim.fn.stdpath("data")
				.. "/jdtls-workspace/"
				.. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

			local config = {
				cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.level=ALL",
					"-Xmx1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens", "java.base/java.util=ALL-UNNAMED",
					"--add-opens", "java.base/java.lang=ALL-UNNAMED",
					"-jar", launcher,
					"-configuration", mason_path .. "/config_win",
					"-data", workspace,
				},
				root_dir = require("jdtls.setup").find_root({
					".git",
					"mvnw",
					"gradlew",
					"pom.xml",
					"build.gradle",
				}),
				settings = {
					java = {
						eclipse = { downloadSources = true },
						maven = { downloadSources = true },
						implementationsCodeLens = { enabled = true },
						referencesCodeLens = { enabled = true },
						format = { enabled = false },
					},
				},
				on_attach = function(client, bufnr)
					local opts = { noremap = true, silent = true, buffer = bufnr }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				end,
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					require("jdtls").start_or_attach(config)
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-vsnip",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
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
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
					{ name = "buffer" },
					{ name = "path" },
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
					separator_style = "thin",
					show_buffer_close_icons = false,
					show_close_icon = false,
					show_buffer_icons = false,
					offsets = {},
				},
			})
		end,
	},
	{ "fatih/vim-go", ft = { "go" } },
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
		vim.notify("Lazy.nvim belum dimuat!", vim.log.levels.ERROR)
		return
	end

	local stats = lazy.stats()
	if not stats or not stats.plugins then
		vim.notify("Tidak ada data profil plugin yang tersedia", vim.log.levels.WARN)
		return
	end

	local sorted = {}
	for name, data in pairs(stats.plugins) do
		table.insert(sorted, { name = name, time = data.time or 0 })
	end
	table.sort(sorted, function(a, b)
		return a.time > b.time
	end)

	local msg = "Plugin paling berat (Top 10)\n\n"
	for i = 1, math.min(10, #sorted) do
		local p = sorted[i]
		msg = msg .. string.format("%2d. %-25s %.2f ms\n", i, p.name, p.time)
	end

	vim.notify(msg, vim.log.levels.INFO, { title = "Lazy.nvim Profiling" })
end, { desc = "Tampilkan plugin paling berat di Lazy.nvim" })

map("n", "<leader>ttt", OpenRightTerminals, opts)
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
map("n", "<Space>E", vim.diagnostic.open_float, opts)
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>qq", ":qa!<CR>", opts)
map("n", "<leader>t", ":tabnew<CR>", opts)
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

map("i", "<Space>n", function()
	require("cmp").complete()
end, { noremap = true, silent = true, expr = false, desc = "Trigger completion menu" })
