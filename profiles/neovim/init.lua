local opt = vim.opt
local api = vim.api
local cmd = vim.cmd

vim.g.mapleader = " "
cmd([[set nowrap]])
cmd([[set noswapfile]])
cmd([[set cursorline]])
cmd([[set splitbelow]])
cmd([[set splitright]])
opt.background = "dark"
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

opt.expandtab = true
opt.smarttab = true
opt.tabstop = 2
opt.shiftwidth = 2
api.nvim_create_autocmd("FileType", {
  pattern = "go",
  command = "setlocal noexpandtab tabstop=4 shiftwidth=4",
})

opt.list = true
opt.listchars:append("eol:↴")

opt.ignorecase = true
opt.smartcase = true

require("tokyonight").setup {
  transparent = true,
}
vim.o.termguicolors = true
cmd("colorscheme tokyonight")

local actions = require("telescope.actions")
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
    path_display = { "smart" },
  },
}
api.nvim_set_keymap('n', '<leader>ff', [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true })
api.nvim_set_keymap('n', '<leader>fg', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true })
api.nvim_set_keymap('n', '<leader>fb', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true })
api.nvim_set_keymap('n', '<leader>fh', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true })
api.nvim_set_keymap('n', '<leader>fo', [[<Cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true })

require('gitsigns').setup {
  attach_to_untracked = false,
  current_line_blame = true,
  preview_config = {
    border = "rounded",
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line { full = true } end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

require("indent_blankline").setup {
  show_end_of_line = true,
}

require('nvim-autopairs').setup {
  fast_wrap = {},
}
local npairs   = require 'nvim-autopairs'
local Rule     = require 'nvim-autopairs.rule'
local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
npairs.add_rules {
  Rule(' ', ' ')
      :with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({
          brackets[1][1] .. brackets[1][2],
          brackets[2][1] .. brackets[2][2],
          brackets[3][1] .. brackets[3][2],
        }, pair)
      end)
}
for _, bracket in pairs(brackets) do
  npairs.add_rules {
    Rule(bracket[1] .. ' ', ' ' .. bracket[2])
        :with_pair(function() return false end)
        :with_move(function(opts)
          return opts.prev_char:match('.%' .. bracket[2]) ~= nil
        end)
        :use_key(bracket[2])
  }
end

require('nvim-treesitter.configs').setup {
  parser_install_dir = "$HOME/.local/share/nvim/site",
  highlight = {
    enable = true,
  },
}

require('tabline').setup {
  enable = true,
}
cmd [[
  set guioptions-=e " Use showtabline in gui vim
  set sessionoptions+=tabpages,globals " store tabpages and globals in session
]]

require('lualine').setup {
  options = {
    theme = 'tokyonight',
  },
}

require('nvim-tree').setup {
  sync_root_with_cwd = true,
  view = {
    preserve_window_proportions = true,
  },
  renderer = {
    full_name = true,
    highlight_git = true,
    group_empty = true,
    special_files = {},
    symlink_destination = false,
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        folder = false,
        folder_arrow = false,
        git = false,
      },
    },
  },
  update_focused_file = {
    enable = true,
  },
  filters = {
    custom = {
      "^.git$",
      "^.bloop$",
      "^.metals$",
    },
  },
}
api.nvim_set_keymap('n', '<leader>tt', ':NvimTreeToggle<CR>', { noremap = true })
api.nvim_set_keymap('n', '<leader>tf', ':NvimTreeFocus<CR>', { noremap = true })

local fn = vim.fn

function _G.qftf(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%5d:%-3d│%s %s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'

-- Adapt fzf's delimiter in nvim-bqf
require('bqf').setup({
  filter = {
    fzf = {
      extra_opts = { '--bind', 'ctrl-o:toggle-all', '--delimiter', '│' },
    },
  },
})
