set nocompatible " be iMproved

" Setting up Vundle - the vim plugin bundler
let has_vundle=1
if !filereadable($HOME."/.vim/bundle/Vundle.vim/README.md")
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
    let has_vundle=0
endif

" For Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Dependencies of snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'honza/vim-snippets'

" Git tools
Plugin 'tpope/vim-fugitive'
" Dependency managment
Plugin 'VundleVim/Vundle.vim'
" Rails :/
Plugin 'tpope/vim-rails.git'
" Snippets for our use :)
Plugin 'garbas/vim-snipmate'
" Commenting and uncommenting stuff
Plugin 'tomtom/tcomment_vim'
" Molokai theme
Plugin 'tomasr/molokai'
" Zenburn theme
Plugin 'Zenburn'
" Vim Ruby
Plugin 'vim-ruby/vim-ruby'
" Surround your code :)
Plugin 'tpope/vim-surround'
" Every one should have a pair (Autogenerate pairs for "{[( )
Plugin 'jiangmiao/auto-pairs'
" Tab completions
Plugin 'ervandew/supertab'
" Fuzzy finder for vim (CTRL+P)
Plugin 'kien/ctrlp.vim'
" For tests
"Plugin 'janko-m/vim-test'
" Navigation tree
Plugin 'scrooloose/nerdtree'
" Dispatching the test runner to tmux pane
"Plugin 'tpope/vim-dispatch'

Plugin 'plasticboy/vim-markdown'

call vundle#end()

" ============================================================================
" Install plugins the first time vim runs
if has_vundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :silent! PluginInstall
    :qa
endif

filetype plugin indent on

set tags=./tags; " Set tags directory
set autoindent " Auto indention should be on

" Ruby stuff: Thanks Ben :)
" ================
syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype-specific indenting and plugins

augroup myfiletypes
    " Clear old autocmds in group
    autocmd!
    " autoindent with two spaces, always expand tabs
    autocmd FileType ruby,eruby,yaml,markdown set ai sw=2 sts=2 et
augroup END
" ================

" Syntax highlighting and theme

syntax enable

" Configs to make Molokai look great
set background=dark
"let g:molokai_original=1
let g:rehash256=1
set t_Co=256
"colorscheme zenburn
"colorscheme molokai
" I like my comments italicized
" highlight Comment cterm=italic

" set colorcolumn=90
" hi ColorColumn guibg=#33332f ctermbg=238

" Show trailing whitespace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\\t/

" Lovely linenumbers
set nu

" My leader key
let mapleader=","

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
" Remove highlights with leader + enter
nmap <Leader><CR> :nohlsearch<cr>

" Buffer switching
map <leader>p :bp<CR> " \p previous buffer
map <leader>n :bn<CR> " \n next buffer
map <leader>d :bd<CR> " \d delete buffer

map <Leader>c :call <CR>
"nmap <silent> <leader>c :TestFile<CR>
"nmap <silent> <leader>s :TestNearest<CR>
"map <leader>t :A<CR> " \t to jump to test file
"map <leader>r :r<cr> " \t to jump to related file

set laststatus=2

" Don't be a noob, join the no arrows key movement
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" Removing escape
ino jj <esc>
cno jj <c-c>
vno v <esc>

" highlight the current line
"set cursorline
" Highlight active column
"set cuc cul"

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*
""""""""""""""""""""""""""""""""""""""""
" BACKUP / TMP FILES
""""""""""""""""""""""""""""""""""""""""
if isdirectory($HOME . '/.vim/backup') == 0
    :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Save your swp files to a less annoying place than the current directory.
" " If you have .vim-swap in the current directory, it'll use that.
" " Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
    :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
    " undofile - This allows you to use undos after exiting and restarting
    " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
    " :help undo-persistence
    " This is only present in 7.3+
    if isdirectory($HOME . '/.vim/undo') == 0
        :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
    endif
    set undodir=./.vim-undo//
    set undodir+=~/.vim/undo//
    set undofile
endif

" Ruby hash syntax conversion
nnoremap <F12> :%s/:\([^ ]*\)\(\s*\)=>/\1:/g<return>

nmap <Leader><CR> :nohlsearch<cr>

map <leader>q :NERDTreeToggle<CR>

set clipboard=unnamed

" Reload vimrc
map <leader>s :source ~/.vimrc<CR>

"if has('nvim')
"  let test#strategy = "neovim"
"else
"  let test#strategy = "dispatch"
"endif

function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>
