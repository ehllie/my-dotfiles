local function setup(comment, util, api)
  comment.setup({
    pre_hook = function(ctx)
      local location = nil
      if ctx.ctype == util.ctype.block then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == util.cmotion.v or ctx.cmotion == util.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring({
        key = ctx.ctype == util.ctype.line and "__default" or "__multiline",
        location = location,
      })
    end,
  })

  local keymap = vim.keymap.set
  local opts = { silent = true }

  keymap("n", "<leader>/", api.toggle_current_linewise, opts)
  keymap("x", "<leader>/", function()
    api.toggle_linewise_op(vim.fn.visualmode())
  end, opts)
end

return { deps = { "Comment", "Comment.utils", "Comment.api" }, setup = setup }
