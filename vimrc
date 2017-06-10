set nocompatible                  " Must come first because it changes other options.

silent! call pathogen#runtime_append_all_bundles()
"execute pathogen#infect()

syntax enable                     " Turn on syntax highlighting.
filetype plugin indent on         " Turn on file type detection.

set nobackup                      " Disable swaps & backups
set noswapfile

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Normal line number
set ruler                         " Show cursor position.

set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.

set nowrap                          " Turn on line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.
set textwidth=0
set colorcolumn=80

set list listchars=tab:\ \ ,trail:•

set visualbell                    " No beeping.

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set directory=~/.vim/tmp,.  " Keep swap files in one location

set tabstop=2                     " Global tab width.
set shiftwidth=2                  " And again, related.
set expandtab                     " Use spaces instead of tabs

set cursorline

set title                         " Set the terminal's title

set gdefault                      " Default regexes to global
set laststatus=2

set autoindent                    " Keep indentation from previous line
set smartindent                   " Automatically inserts indentation in some cases
set cindent                       " Like smartindent, but stricter and more customisable

set foldmethod=indent             " Fold based on indent
set foldnestmax=10                " Deepest fold is 10 levels
set nofoldenable                  " Dont fold by default
set foldlevel=0                   " This is just what I use


" Neocomplcache Settings
let g:neocomplcache_enable_at_startup = 1

" From GRB's .vimrc - makes current window have a min size
set winwidth=84
set winminwidth=20
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=10
set winminheight=10
set winheight=999


" Remaps

" Use tab to jump between do/end etc.
nnoremap <tab> %
vnoremap <tab> %s

" Remove trailing whitespace
nnoremap <Leader>w :%s/\s\+$//<CR>


" Appearance

hi Cursor guibg=white
hi Visual guibg=#333333 guifg=#EEEEEE
hi ColorColumn guibg=#f1f1f1

" SignColumn
hi SignColumn term=standout ctermfg=11 ctermbg=8 guifg=Cyan guibg=#666666
hi Error term=reverse ctermfg=15 ctermbg=12 gui=none guifg=#f26168 guibg=black
hi WarningMsg term=standout ctermfg=15 ctermbg=12 gui=bold guifg=#ffe296 guibg=black

" NERDTree colors

" autocmd VimEnter * hi NERDTreeDir guifg=#eeeeee gui=bold
" autocmd VimEnter * hi NERDTreeDirSlash guifg=#eeeeee
" autocmd VimEnter * hi NERDTreeExecFile gui=none

" set background=dark
" colorscheme solarized
"colorscheme ir_black
" colorscheme torte
"colorscheme twilight
"colorscheme Tomorrow-Night
" colorscheme topfunky-light
colorscheme Tomorrow-Night-Eighties

runtime macros/matchit.vim        " Load the matchit plugin.

" Tab mappings.
map <leader>tt :tabnew<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>to :tabonly<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>
map <leader>tf :tabfirst<cr>
map <leader>tl :tablast<cr>
map <leader>tm :tabmove

" NERDTree
map <leader>no :NERDTree<cr>
map <leader>nt :NERDTreeToggle<cr>
map <leader>nf :NERDTreeFind<cr>
map <leader>nm :NERDTreeMirror<cr>
map <leader>nq :NERDTreeClose<cr>

" Rails Plugin
map <leader>rm :Rmodel<cr>
map <leader>rc :Rcontroller<cr>
map <leader>rv :Rview<cr>
map <leader>rM :Rmigration<cr>

" Tabular Alignment
map <leader>ia= vi} :Tabularize /=<cr>
map <leader>ia: vi} :Tabularize /:\zs<cr>
map <leader>a= :Tabularize /=<cr>
map <leader>a: :Tabularize /:\zs<cr>
let mapleader=','
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" VimGrep Searches Highlighted
map <leader>f :execute "vimgrep /" . expand("<cword>") . "/j **" <bar> cw<cr>

" Automatic fold settings for specific files. Uncomment to use.
autocmd FileType ruby setlocal foldmethod=syntax
autocmd FileType css  setlocal foldmethod=indent shiftwidth=4 tabstop=4

" For the MakeGreen plugin and Ruby RSpec. Uncomment to use.
autocmd BufNewFile,BufRead *_spec.rb compiler rspec

" Makes Markdown file extension recognized
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

