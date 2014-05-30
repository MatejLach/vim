"" The Absolute Must ""
syntax on
set encoding=utf-8
set fileformats=unix,dos,mac " UNIX first
filetype plugin indent on

" pathogen
execute pathogen#infect()


"" User Interface ""
" 256 colour support
set t_Co=256
" Colour theme
try
    colorscheme desert256
catch
endtry

" set GViM font
if has('gui_running')
  set guifont=set guifont=Source\ Code\ Pro\ Semi-Bold\ 30
endif
" set GViM size
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=999 columns=999
else
  " This is console Vim.
  if exists("+lines")
    set lines=50
  endif
  if exists("+columns")
    set columns=122
  endif
endif

" line numbering
set number
" in the name of sanity
set noerrorbells " disable beeps
" sane backspace
set backspace=indent,eol,start
" I know what I am doing
set noswapfile
set nobackup " Yes, I am serious
" Show me what I'm doing
set showcmd
" Show me the current mode
set showmode
" Auto-write changes
set autowrite
" Auto-read outside changes
set autoread
" Show search results while typing
set incsearch
" Highlight found search results
set hlsearch
" Search should not be case sensitive
set ignorecase
set smartcase " unless I explicitly search for upcase characters
" Always open a new buffer in new tab
set switchbuf=usetab,newtab


"" Shortcuts ""
" New file
nnoremap <C-n> :new<CR>
" Open file
nnoremap <C-o> :FufFile<CR>
" Close buffer
nnoremap <C-q> :bd!<CR>
" Set <Tab> to 4 spaces
set shiftwidth=4
set tabstop=4
" Remap quicksave
noremap <C-w> :update<CR>
vnoremap <C-w> <C-C>:update<CR>
" Remap quit command
noremap <C-e> :quit<CR>
" Find
map <C-f> /
" indend / deindent after selecting the text with (⇧ v), (.) to repeat.
vmap <Tab> >
vmap <S-Tab> <
" comment / decomment & normal comment behavior
vmap <C-m> gc
" Disable tComment to escape some entities
let g:tcomment#replacements_xml={}
" Text wrap simpler, then type the open tag or ',"
vmap <C-w> S
" Cut, Paste, Copy
vmap <C-x> d
vmap <C-v> p
vmap <C-c> y
" Gundo - undo tree
nnoremap <F9> :GundoToggle<CR>
" Tabs
let g:airline_theme='badwolf'
let g:airline#extensions#tabline#enabled = 1
nnoremap <C-b>  :tabprevious<CR>
inoremap <C-b>  <Esc>:tabprevious<CR>i
nnoremap <C-n>  :tabnext<CR>
inoremap <C-n>  <Esc>:tabnext<CR>i
nnoremap <C-t>  :tabnew<CR>
inoremap <C-t>  <Esc>:tabnew<CR>i
nnoremap <C-k>  :tabclose<CR>
inoremap <C-k>  <Esc>:tabclose<CR>i
" Snippets
let g:UltiSnipsExpandTrigger="<F6>"
let g:UltiSnipsJumpForwardTrigger="<F7>"
let g:UltiSnipsJumpBackwardTrigger="<F5>"
" Tagbar
nmap <F8> :TagbarToggle<CR>

"" Golang specific shortcuts ""
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

" lightline.vim config
" statusline always enabled
set laststatus=2
let g:Powerline_symbols = 'fancy'

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'readonly': 'MyReadonly',
      \   'modified': 'MyModified',
      \   'filename': 'MyFilename'
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

function! MyModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! MyReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "⭤"
  else
    return ""
  endif
endfunction

function! MyFugitive()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? '⭠ '._ : ''
  endif
  return ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction


"" Misc
" man plugin
source /usr/share/vim/vim74/ftplugin/man.vim
" View manpages using Vim
let $PAGER=''
" Sane clipboard
set clipboard=unnamed
" Fix backspace
set bs=2
" Autoreload .vimrc
autocmd! bufwritepost .vimrc source %


" GitHub Gist settings "
" The settings are self-explanatory
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1 
let g:gist_post_private = 1
