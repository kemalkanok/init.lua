local nmap = function(keys, func, desc)
    if desc then
        desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end
vim.cmd 'noremap <C-S-Down> <Esc>:m+1<CR>'
vim.cmd 'noremap <C-S-Up>   <Esc>:m-2<CR>'

vim.cmd 'vnoremap <TAB> >>'
vim.cmd 'vnoremap <S-TAB> <<'
vim.g.mapleader = " "
nmap("<leader>pv", vim.cmd.Ex, "Back to Explorer")
nmap("<leader>ssv", vim.cmd.vsp, "Split Screen Vertical")
nmap("<leader>ssh", vim.cmd.sp, "Split Screen Horizontal")
-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("v", "<C-/>", "<Esc>:'<,'>norm i//<CR>")
vim.keymap.set("v", "<C-S-/>", "<Esc>:'<,'>norm xx<CR>")

nmap('<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, "[P]roject '[S]earch")

nmap("<leader>f", vim.lsp.buf.format, "[F]ormat")
-- See `:help telescope.builtin`
nmap('<leader>?', require('telescope.builtin').oldfiles, '[?] Find recently opened files')
nmap('<leader><space>', require('telescope.builtin').buffers, '[ ] Find existing buffers')
-- nmap('<leader>/', function()
--     -- You can pass additional configuration to telescope to change theme, layout, etc.
--     require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--         winblend = 10,
--         previewer = false,
--     })
-- end, '[/] Fuzzily search in current buffer')

require('telescope').setup { defaults = { file_ignore_patterns = { "node_modules", "dist", "vendor" } } }

nmap('<leader>gf', require('telescope.builtin').find_files, '[G]it [F]iles')
nmap('<leader>sf', require('telescope.builtin').find_files, '[S]earch [F]iles')
nmap('<C-p>', require('telescope.builtin').find_files, '[S]earch [F]iles')
nmap('<leader>sh', require('telescope.builtin').help_tags, '[S]earch [H]elp')
nmap('<leader>sw', require('telescope.builtin').grep_string, '[S]earch current [W]ord')
nmap('<leader>sg', require('telescope.builtin').live_grep, '[S]earch by [G]rep')
nmap('<leader>sd', require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics')
--tree-sitter
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "javascript", "typescript", "html", "lua", "php", "css", "scss", "bash" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        -- `false` will disable the whole extension
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}


--lsp
--

local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    --'rust_analyzer',
    "lua_ls",
    "cssls",
    --  "scss",
    "html",
    "tailwindcss",
    "intelephense",
    -- "phpactor",
    -- "psalm"
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})



lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})




nmap('<leader>gd', ':lua vim.lsp.buf.definition()<CR>', '[G]o To [D]efinition')
nmap('<leader>gv', ':vsplit | lua vim.lsp.buf.definition()<CR>', '[G]o To Definition [V]ertical Split')
nmap('<leader>gh', ':belowright split |:resize 15 | lua vim.lsp.buf.definition()<CR>',
    '[G]o To Definition [H]orizontal Split')

nmap("K", vim.lsp.buf.hover, "Hover")
nmap("<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols")
nmap("<leader>d", vim.diagnostic.open_float, "")
nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
nmap("<leader>gr", vim.lsp.buf.references, "[G]o To [R]eferences")
nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")

vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
--vim.keymap.set("i", "<C-k>", vim.lsp.buf.hover)

--refactoring
require('refactoring').setup({})

vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
    { noremap = true, silent = true, expr = false })


-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
    { noremap = true, silent = true, expr = false, desc = "LSP: [R]efactor [E]xtract Method" })
vim.api.nvim_set_keymap("v", "<leader>rf",
    [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
    { noremap = true, silent = true, expr = false, desc = "LSP: [R]efactor Extract Method to [F]ile" })
vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
    { noremap = true, silent = true, expr = false, desc = "LSP: [R]efactor Extract [V]ariable" })
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
    { noremap = true, silent = true, expr = false, desc = "LSP: [R]efactor [I]nline Variable" })

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
    { noremap = true, silent = true, expr = false, desc = "LSP: [R]efactor Extract [B]lock" })
vim.api.nvim_set_keymap("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
    { noremap = true, silent = true, expr = false, desc = "LSP: [R]efactor Extract [B]lock To [F]ile" })

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
    { noremap = true, silent = true, expr = false, desc = "LSP: [R]efactor [I]nline Variable" })


--nvim-tree

-- OR setup with some options
require("nvim-tree").setup({
    sort_by = "name",
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,

    },
})

local api = require('nvim-tree.api')
api.tree.open({ path = "<arg>" })

--toggler
require('Comment').setup()
-- Toggle in Op-pending mode
vim.keymap.set('n', '<leader>//', '<Plug>(comment_toggle_linewise)<CR>')

-- Toggle in VISUAL mode
vim.keymap.set('x', '<leader>//', '<Plug>(comment_toggle_linewise_visual)<CR>')
