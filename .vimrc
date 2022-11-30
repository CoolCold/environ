set nocompatible
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
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
"set listchars=eol:¶
"set listchars=eol:¬
"set listchars=eol:˩
"set listchars=eol:┘
set listchars=eol:┐
set list
set lazyredraw " The screen will not be redrawn while executing macros
syntax on
" colorscheme evening
" colorscheme lucius
colorscheme solarized8
" colorscheme desert256

set background=dark
" colorscheme lucius
colorscheme solarized8

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
  autocmd Filetype python setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4
  autocmd Filetype yaml setlocal cursorcolumn
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


" Netrw file explorer settings
let g:netrw_banner = 0 " hide banner above files
let g:netrw_liststyle = 3 " tree instead of plain view
let g:netrw_browse_split = 3 " vertical split window when Enter pressed on file


" Use buffers like tabs
set hidden                " Do not complain about switching from unsaved buffer
nnoremap <silent> <C-N> :bnext<cr>
nnoremap <silent> <C-P> :bprevious<cr>
nnoremap <silent> <leader>1 :1buffer<cr>
nnoremap <silent> <leader>2 :2buffer<cr>
nnoremap <silent> <leader>3 :3buffer<cr>
nnoremap <silent> <leader>4 :4buffer<cr>
nnoremap <silent> <leader>5 :5buffer<cr>
nnoremap <silent> <leader>6 :6buffer<cr>
nnoremap <silent> <leader>7 :7buffer<cr>
nnoremap <silent> <leader>8 :8buffer<cr>
nnoremap <silent> <leader>9 :9buffer<cr>
"noremap <C-k> <C-w>k
"noremap <C-j> <C-w>j

"" buftabline
"let g:buftabline_show = 1
"hi BufTabLineCurrent term=bold,reverse ctermfg=15 ctermbg=63 guifg=#ffffff guibg=#5f5fff
"hi BufTabLineActive ctermfg=117 ctermbg=63 guifg=#b0e7ff guibg=#5f5fff
"hi BufTabLineHidden ctermfg=7 ctermbg=63 guifg=#c0c0c0 guibg=#5f5fff
"hi BufTabLineFill ctermfg=254 ctermbg=63 guifg=#f0f0f0 guibg=#5f5fff
"
"" bufexplorer
"let g:bufExplorerDisableDefaultKeyMapping=1
"nnoremap <silent> <leader>b :ToggleBufExplorer<cr>
"
