set nocompatible
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set backspace=indent,eol,start
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2
set showcmd
set showmatch
set ignorecase
set smartcase
set incsearch
"set autowrite
set hidden
set hlsearch
set smartindent
set autoindent
set modeline
set modelines=5
syntax on
" colorscheme evening
colorscheme lucius
" colorscheme desert256

set background=dark
colorscheme lucius

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif


" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
  autocmd BufNewFile,BufRead *.conf set filetype=conf
  " for html/rb files, 2 spaces
  autocmd Filetype html setlocal ts=2 sw=2 expandtab
  autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
endif

""key bind/rebinds
"nmap <F5> :set paste<cr>i

"{{{ Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
   if g:paste_mode == 0
      set paste
      let g:paste_mode = 1
   else
      set nopaste
      let g:paste_mode = 0
   endif
   return
endfunc
"}}}
" Paste Mode!  Dang! <F10>
nnoremap <silent> <F10> :call Paste_on_off()<CR>
set pastetoggle=<F10>
vnoremap // y/<C-R>"<CR>
