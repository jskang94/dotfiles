local cmp = require('cmp')

cmp.setup({
  enabled = function()
    -- disable completion in comments
    local context = require 'cmp.config.context'
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture("comment") 
        and not context.in_syntax_group("Comment")
    end
  end,
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {},
  sources = {
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 8 },
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({cmp.SelectBehavior.Select}),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({cmp.SelectBehavior.Select}),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
})
