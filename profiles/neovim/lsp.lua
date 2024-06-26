local api = vim.api

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format { async = true }<CR>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]])                 -- all workspace diagnostics
map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>")                   -- buffer diagnostics only
map('n', '<leader>e', "<cmd>lua vim.diagnostic.open_float()<CR>")
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

local cmp = require('cmp')
local luasnip = require("luasnip")
local lspkind = require('lspkind')

cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end, { "i", "s" }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'treesitter' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
  window = {
    completion = {
      border = 'rounded',
      scrollbar = '║',
    },
    documentation = {
      border = nil,
      scrollbar = '',
    },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 80,
      ellipsis_char = '...',
    })
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil
end

require('lspconfig').pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').clangd.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  },
}

require('lspconfig').glsl_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').lua_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

require('lspconfig').nixd.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require("lsp_signature").setup {
  bind = true,
  handler_opts = {
    border = "rounded",
  },
}

require('gen').setup {
  model = "codestral",
  init = nil,
  display_mode = "split",
}
vim.keymap.set({ 'n', 'v' }, '<leader>]', ':Gen<CR>')

require('llm').setup {
  model = "codellama:code",
  backend = "ollama",
  url = "http://localhost:11434/api/generate",
  request_body = {
    options = {
      temperature = 0,
      top_p = 0.9,
    }
  },
  tokens_to_clear = { "<EOT>" },
  fim = {
    enabled = true,
    prefix = "<PRE> ",
    middle = " <MID>",
    suffix = " <SUF>",
  },
  accept_keymap = "<M-j>",
  dismiss_keymap = "<M-h>",
  context_window = 1024,
  lsp = {
    bin_path = llm_ls_bin_path,
    version = "0.5.2",
  },
  enable_suggestions_on_startup = false,
}
