set nocompatible

" Setting up Vundle - the vim plugin bundler
let has_vundle=1
if !filereadable($HOME."/.vim/bundle/Vundle.vim/README.md")
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle $HOME/.vim/bundle/Vundle.vim
    let has_vundle=0
endif

filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all Vundle Plugins here
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'molokai'

" All Plugins must be added before the following line
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

set guifont=Inconsolata\ 14
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set termencoding=utf-8
set encoding=utf-8

let python_highlight_all=1
syntax on

set clipboard=unnamed

if has('gui_running')
  set background=dark
  colorscheme solarized
else
  set background=dark
  colorscheme zenburn
endif

highlight Comment cterm=italic

" split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za
" Show docstrings for folded code
let g:SimpylFold_docstring_preview=1

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 | 
    \ set softtabstop=2 | 
    \ set shiftwidth=2 |

" Flag whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

set laststatus=2
