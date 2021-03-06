"" The Absolute Must
syntax on
set encoding=utf-8
set fileformats=unix,dos,mac " UNIX first
filetype plugin indent on
let g:neocomplcache_enable_at_startup = 1

" pathogen
execute pathogen#infect()


"" User Interface
" 256 colour support
set t_Co=256
" Colour theme
try
    colorscheme devbox-dark-256 
catch
endtry

" set GViM font
if has('gui_running')
  set guifont=set guifont=Source\ Code\ Pro\ Semi-Bold\ 24
endif

" line numbering
set number
" in the name of sanity
set noerrorbells " disable beeps
" sane backspace
set backspace=indent,eol,start
" I know what I am doing
set noswapfile
set nobackup " Yes, I am serious, use Git instead
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
" Search should not be case sensitive
set ignorecase
set smartcase " unless I explicitly search for upcase characters
" Always open a new buffer in new tab
set switchbuf=usetab,newtab
" Indent
set tabstop=4
set shiftwidth=4
set expandtab


"" Shortcuts
" New file
nnoremap <C-n> :new<CR>
" Open file
nnoremap <C-o> :FufFile<CR>
" NERDTree
nnoremap <S-p> :NERDTree<CR>
let NERDTreeWinSize = 20
" Close buffer
nnoremap <C-q> :bd!<CR>

" Tags
set tags=tags;
" Tagbar
nmap <S-s> :TagbarToggle<CR>

" Autocomplete with <TAB>
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Remap quicksave
noremap <C-u> :update<CR>
vnoremap <C-u> <C-C>:update<CR>
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
" Windows
nmap <F2> :wincmd k<CR>
nmap <F3> :wincmd j<CR>
nmap <F10> :wincmd h<CR>
nmap <F12> :wincmd l<CR>
" Buffers
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif
" Snippets
let g:UltiSnipsExpandTrigger="<F6>"
let g:UltiSnipsJumpForwardTrigger="<F7>"
let g:UltiSnipsJumpBackwardTrigger="<F5>"


" Haskell options
" Tagbar
let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }
" Other options
let g:haskell_conceal_wide = 1
let g:haskell_multiline_strings = 1
let g:necoghc_enable_detailed_browse = 1
map <Leader>s :GhcModType<CR>

" Go specific settings
" Tagbar
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
" Golang specific shortcuts
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

" GitHub Gist settings
" The settings are self-explanatory
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_post_private = 1
