return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath('data') .. '/site'
    }

    require('nvim-treesitter').install { 'cpp', 'c', 'python' }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'cpp', 'python' },
      callback = function() vim.treesitter.start() end,
    })

  end
}
