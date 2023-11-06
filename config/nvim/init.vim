call plug#begin()
  Plug 'Mofiqul/dracula.nvim'
call plug#end()
colorscheme dracula

" Sets clipboard support
"set clipboard=unnamedplus
" Set to auto read when a file is changed from the outside
au FocusGained,BufEnter * silent! checktime
" Sets mapsleader to , instead of \
let mapleader = ","
" Ignore these files when tabbing for files, folders etc.
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
" Make cursor move to nextline when going right or left at end of line
set whichwrap+=<,>,h,l,b,s
" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" Show matching brackets, blinking to the first one when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2
" Disables swapfile
set noswapfile
" Use spaces instead of tabs
set expandtab
" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
" Linebreak on 500 characters
set linebreak
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>
" Always show tab lines
set showtabline=2
" Return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Format the status line
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
" Remap VIM 0 to first non-blank character
map 0 ^
" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

