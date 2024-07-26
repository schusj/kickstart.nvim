-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal' },
  },
  opts = {
    popup_border_style = 'rounded',
    close_if_last_window = true,
    enable_diagnostics = true,
    enable_git_status = true,
    window = {
      position = 'right',
    },
    filesystem = {
      commands = {
        delete = function(state)
          local inputs = require 'neo-tree.ui.inputs'
          local path = state.tree:get_node().path
          local msg = 'Are you sure you want to trash ' .. path
          inputs.confirm(msg, function(confirmed)
            if not confirmed then return end

            vim.fn.system { 'trash', vim.fn.fnameescape(path) }
            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,

        -- over write default 'delete_visual' command to 'trash' x n.
        delete_visual = function(state, selected_nodes)
          local inputs = require 'neo-tree.ui.inputs'

          -- get table items count
          local function getTableLen(tbl)
            local len = 0
            for _ in pairs(tbl) do
              len = len + 1
            end
            return len
          end

          local count = getTableLen(selected_nodes)
          local msg = 'Are you sure you want to trash ' .. count .. ' files ?'
          inputs.confirm(msg, function(confirmed)
            if not confirmed then return end
            for _, node in ipairs(selected_nodes) do
              vim.fn.system { 'trash', vim.fn.fnameescape(node.path) }
            end
            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,
      },
      filtered_items = {
        visible = true,
      },
    },
  },
}
