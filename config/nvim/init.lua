-- Initialize plugin manager
local Plug = vim.fn['plug#']
vim.call('plug#begin')
  Plug 'Mofiqul/dracula.nvim'
  Plug('catppuccin/nvim', {as= 'catppuccin' })
vim.call('plug#end')

vim.cmd.colorscheme('dracula')                      -- Set colorscheme
vim.g.mapleader = ","                               -- Sets mapsleader to , instead of \

local options = {
  clipboard = 'unnamedplus',                      -- Sets clipboard support
  cursorline = true,                              -- Highlights the cursor line
  expandtab = true,                               -- Use spaces instead of tabs
  ignorecase = true,                              -- Ignore case when searching
  lazyredraw = true,                              -- Skip redrawing the screen in some cases
  linebreak = true,                               -- Line break on 500 characters
  matchtime = 2,                                  -- How many tenths of a second to blink when matching brackets
  mouse = 'a',                                    -- Use mouse for all available modes. Default: nvi
  number = true,                                  -- Show line numbers
  pumheight = 10,                                 -- pop up menu height
  relativenumber = true,                          -- Relative line numbering
  scrolloff = 8,                                  -- Minimal number of lines to keep below the cursor
  shiftwidth = 2,                                 -- 1 tab == 2 spaces
  showmatch = true,                               -- Show matching brackets, blinking to the first one when the text indicator is over them
  showtabline = 2,                                -- Always show tab lines
  sidescrolloff = 8,                              -- Minimal number of screen columns to left and right
  smartcase = true,                               -- When searching, try to be smart about cases
  smartindent = true,                             -- make indenting smarter again
  splitbelow = true,                              -- Open new split panes to the right and bottom, which feels more natural
  splitright = true,                              -- Open new split panes to the right and bottom, which feels more natural
  statusline = " %F%m%r%h %w CWD:%r%{getcwd()}%h Line: %l Column: %c", -- Format the status line
  swapfile = false,                               -- Disables swapfile
  tabstop = 2,                                    -- 1 tab == 2 spaces
  timeoutlen = 100,                               -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                                -- enable persistent undo
  updatetime = 300,                               -- faster completion (4000ms default)
  whichwrap = vim.o.whichwrap .. '<,>,h,l,b,s',   -- Make cursor move to the next line when going right or left at the end of the line
  wildignore = '*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store', -- Ignore these files when tabbing for files, folders, etc.
}
-- Loop over above variables
for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.keymap.set('n', '0', '^') -- Remap VIM 0 to first non-blank character
vim.keymap.set('n', '<space>', '/') -- Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
vim.keymap.set('n', '<leader><cr>', ':noh<cr>') -- Disable highlight when <leader><cr> is pressed
-- vim.keymap.set('n', 'y', '"+y', { noremap = true, silent = true }) -- yank to different register to allow pasting outside vim

-- Delete trailing white space on save, useful for some file types ;)
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = {"*.txt,*.js,*.py,*.wiki,*.sh,*.coffee"},
  callback = function(ev)
    save_cursor = vim.fn.getpos(".")
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Set to auto read when a file is changed from the outside
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
  pattern = {"*"},
  command = "silent! checktime",
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = {"*"},
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- Set default syntax for all files
vim.api.nvim_create_autocmd({"BufNewFile" ,"BufRead"}, {
  pattern = {"*"},
  command = "if &ft == '' | set ft=zsh | endif",
})

-- Save read-only files
vim.cmd [[command! -nargs=0 Sudow w !sudo tee % >/dev/null]]

