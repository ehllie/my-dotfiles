local function setup(cmp, luasnip)
  require("luasnip/loaders/from_vscode").lazy_load()

  vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#A29BF1" })

  local kind_icons = {
    Class = "",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "",
    Interface = "",
    Keyword = "",
    Method = "",
    Module = "",
    Operator = "",
    Property = "",
    Reference = "",
    Snippet = "",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = "",
  }

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },

    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
    }),
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = kind_icons[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = "",
          nvim_lua = "",
          luasnip = "",
          buffer = "",
          path = "",
          emoji = "",
        })[entry.source.name]

        if entry.source.name == "copilot" then
          vim_item.kind = ""
          vim_item.kind_hl_group = "CmpItemKindCopilot"
        end

        return vim_item
      end,
    },
    sources = {
      { name = "copilot" },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "luasnip" },
      { name = "nvim_lsp_signature_help" },
      { name = "buffer" },
      { name = "path" },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    experimental = {
      ghost_text = false,
    },
  })
end

return { deps = { "cmp", "luasnip" }, setup = setup }
