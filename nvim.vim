set nocompatible

" Add some missing filetype extentions
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.yaml  set filetype=yml
autocmd BufNewFile,BufRead *.j2	   set filetype=jinja
autocmd BufNewFile,BufRead *mutt-* set filetype=mail
autocmd BufNewFile,BufRead *.kt set filetype=kotlin

call plug#begin('~/.local/share/nvim/plugged')

" Style
Plug 'chriskempson/base16-vim'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'mhinz/vim-signify'                " VCS diff
Plug 'tpope/vim-fugitive'               " GIT
Plug 'ryanoasis/vim-devicons'
Plug 'eugen0329/vim-esearch'
Plug 'lambdalisue/suda.vim'
" Text navigation
Plug 'nacitar/terminalkeys.vim'
Plug 'junegunn/vim-easy-align'
" File/Tag browsing
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'

Plug 'rhysd/vim-grammarous'

Plug 'liuchengxu/vim-clap'

Plug 'lilydjwg/colorizer'       " color hexa code (eg: #0F12AB)
Plug 'luochen1990/rainbow'      " special parenthesis colors
Plug 'inside/vim-search-pulse'
Plug 'brooth/far.vim'

" Language
Plug 'dense-analysis/ale'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'jaxbot/semantic-highlight.vim'                                                   " semantic highlight (permanent)
Plug 'numirias/semshi',               {'do': ':UpdateRemotePlugins', 'for': 'python'}  " semantic highlight (selected/python)
Plug 'mgedmin/python-imports.vim'
Plug 'martinda/Jenkinsfile-vim-syntax'


Plug 'dbeniamine/vim-mail',           {'for': 'mail'}

"Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}
Plug 'vim-python/python-syntax',      {'for': 'python'}
"
Plug 'chr4/nginx.vim'
"Plug 'vim-scripts/spec.vim',          {'for': 'spec'}
"Plug 'spf13/PIV',                     {'for': 'php'}
"Plug 'Rykka/riv.vim',                 {'for': 'rst'}
"Plug 'rodjek/vim-puppet',             {'for': 'puppet'}
"
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

Plug 'HerringtonDarkholme/yats.vim',       {'for': ['javascript', 'javascriptreact']}
Plug 'yuezk/vim-js',       {'for': ['javascript', 'javascriptreact']}
Plug 'maxmellon/vim-jsx-pretty',       {'for': 'javascriptreact'}

Plug 'groenewege/vim-less',           {'for': 'less'}
Plug 'elzr/vim-json',                 {'for': 'json'}
"Plug 'tpope/vim-rails',               {'for': 'ruby'}
Plug 'tpope/vim-markdown',            {'for': 'markdown'}
""""Plug 'racer-rust/vim-racer'           " rust
Plug 'vim-scripts/HTML-AutoCloseTag', {'for': ['html', 'xml']}
Plug 'hail2u/vim-css3-syntax',        {'for': 'css'}
Plug 'zinit-zsh/zinit-vim-syntax'
"Plug 'udalov/kotlin-vim',             {'for': 'kotlin'}

call plug#end()


set encoding=utf8
scriptencoding utf-8
syntax on
filetype plugin indent on
set shell=/bin/sh

"set clipboard=unnamed,unnamedplus
set mouse=
set hidden                      " Allow buffer switching without saving
set backup                      " Backups are nice ...
set undofile                    " So is persistent undo ...
set undolevels=1000             " Maximum number of changes that can be undone
set undoreload=10000            " Maximum number lines to save for undo on a buffer reload
set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
"set number                      " Line numbers on
"set relativenumber              " 0 is current line
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
"set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
"set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
"set list
"set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
"set matchpairs+=<:>             " Match, to be used with %
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
set nofoldenable                " No fold
set scrolloff=10                " Again no fold
syn spell toplevel              " Spell rst issue https://github.com/Rykka/riv.vim/issues/8
set nohlsearch

set guioptions-=M  "remove menu bar
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar

set ttimeout
set ttimeoutlen=50

let mapleader = ","
let g:mapleader = ","
let maplocalleader = ";"
let g:maplocalleader = ";"

" http://snk.tuxfamily.org/log/vim-256color-bce.html
" Disable Background Color Erase (BCE) so that color schemes
" work properly when Vim is used inside tmux and GNU screen.
if &term =~ '256color'
  set t_ut=
endif

nnoremap P "0p                            " Paste last yank
nnoremap Y y$                             " Yank from the cursor to the end of the line, to be consistent with C and D.
nmap <silent> <leader>/ :nohlsearch<CR>   " Clean hlsearch on new search
command! Notes execute "help mynotes"
command! R execute "source ~/.config/nvim/init.vim"

" ###############
" ### ON LOAD ###
" ###############

" Change cwd to file directory
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
" Cut at 80 for some filetype
autocmd FileType c,cpp,java,go,php,javascript,javascriptreact,puppet,rst set textwidth=79
autocmd FileType python set textwidth=90

" libvirt C style, skip me if editorconfig is present ?
autocmd BufWritePre,BufRead *.c setlocal smartindent cindent cinoptions=(0,:0,l1,t0,L3
autocmd BufWritePre,BufRead *.h setlocal smartindent cindent cinoptions=(0,:0,l1,t0,L3

autocmd FileType Jenkinsfile set shiftwidth=2 tabstop=2 softtabstop=2

"autocmd BufWritePre,BufRead *.cpp setlocal shiftwidth=4 expandtab tabstop=4 softtabstop=4
"autocmd BufWritePre,BufRead *.c setlocal shiftwidth=4 expandtab tabstop=4 softtabstop=4
"autocmd BufWritePre,BufRead *.h setlocal shiftwidth=4 expandtab tabstop=4 softtabstop=4

" Javascript people like 2 chars sep
autocmd FileType javascript,javascriptreact set shiftwidth=2 tabstop=4 softtabstop=4

match ErrorMsg /\s\+$\| \+\ze\t/

"" Restore cursor position
if (&ft!='mail')
    function! ResCur()
        if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
        endif
    endfunction
    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END
endif

" ##############
" ### Themes ###
" ##############
"set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
let base16colorspace=256
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
else
  colorscheme base16-eighties
endif


set cursorline
set laststatus=2        " Show statusbar

" ###############
" ### AIRLINE ###
" ###############
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_theme = 'base16_eighties'

nmap <leader>& <Plug>AirlineSelectTab1
nmap <leader>é <Plug>AirlineSelectTab2
nmap <leader>" <Plug>AirlineSelectTab3
nmap <leader>' <Plug>AirlineSelectTab4
nmap <leader>( <Plug>AirlineSelectTab5
nmap <leader>- <Plug>AirlineSelectTab6
nmap <leader>è <Plug>AirlineSelectTab7
nmap <leader>_ <Plug>AirlineSelectTab8
nmap <leader>ç <Plug>AirlineSelectTab9

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <S-left>  <Plug>AirlineSelectPrevTab
nmap <S-right> <Plug>AirlineSelectNextTab


nmap <leader>i :ImportName<CR>

" ############
" ### JEDI ###
" ############

autocmd FileType python call LoadVirtualEnv()

" Use system python for neovim itself
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
let g:python_highlight_all = 1

" ###########
" ### ALE ###
" ###########

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ale#get_source_options({
  \ 'priority': 10,
  \ }))

let g:ale_completion_enabled = 0
"let g:ale_completion_delay = 5
"set omnifunc=ale#completion#OmniFunc
"set completeopt+=menuone
"set completeopt+=noinsert

let g:ale_sign_column_always = 1  " always show left column
let g:ale_open_list = 1
let g:ale_list_window_size = 7
let g:ale_list_vertical = 0
let g:ale_keep_list_window_open = 1
let g:ale_set_highlights = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

let g:ale_linter_aliases = {'jsx': ['css', 'javascript']}
let g:ale_linters = {}
let g:ale_linters.python = ['pyls'] " , 'flake8']
let g:ale_linters.c = ['clangformat', 'clangd']
let g:ale_linters.cpp = ['clangformat', 'clangd']
let g:ale_linters.go = ['gometalinter']
let g:ale_linters.kotlin = ['ktlint', 'languageserver']
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.jsx = ['stylelint', 'eslint']
let g:ale_fixers = {
  \  'javascript': ['eslint'],
  \  'cpp': ['clang-format'],
  \  '*': ['remove_trailing_lines'],
  \ }
 ", 'trim_whitespace'],
 "
let g:cpp_ccls_init_options = {'clang': { 'extraArgs': '--gcc-toolchain=/usr' }}
let g:ale_cpp_clangd_executable = '/usr/lib/llvm-10/bin/clangd'
let g:ale_c_parse_makefile = 1
let g:ale_c_parse_compile_commands = 1
let g:ale_python_pyls_config = {'pyls': {
  \ 'settings': {"configurationSources": ["flake8"]},
  \ 'plugins': {
  \   'jedi': {'environment': ''},
  \   'pylint': {'enabled': v:false},
  \   'pycodestyle': {'enabled': v:false},
  \   'pyls_mypy': { 'enabled': v:false, "live_mode": v:false },
  \   'pyls_black': { 'enabled': v:true},
  \ }}}

let g:ale_kotlin_languageserver_executable = 'kotlin-language-server'

let g:ale_fix_on_save = 1
"let __ale_c_project_filenames = ['README.md']

" for golang
let g:ale_go_gometalinter_options = '--fast --enable=staticcheck --enable=gosimple --enable=unused'
" let g:ale_go_gometalinter_options = '--fast --vendored-linters --disable-all --enable=gotype --enable=vet --enable=golint -t'

let g:go_fmt_fail_silently = 1

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_sign_error = '⛔'
let g:ale_sign_info = 'ℹ'
let g:ale_sign_offset = 1000000
let g:ale_sign_style_error = '⛔'
let g:ale_sign_style_warning = '⚠'
let g:ale_sign_warning = '⚠'

let g:vim_json_syntax_conceal = 0

" ##################
" ### EASY ALIGN ###
" ##################

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" #############
" ### CTRLP ###
" #############

let g:ctrlp_funky_matchtype = 'path'
let g:ctrlp_funky_syntax_highlight = 1
nnoremap <C-e> :CtrlPFunky<Cr>
nnoremap <C-E> :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

" #######################
" ### Semshi/ALE KEYS ###
" #######################

nmap <silent> <leader>j :ALENext<cr>
nmap <silent> <leader>k :ALEPrevious<cr>
nmap <silent> <leader>dd <Plug>(ale_go_to_definition)
nmap <silent> <leader>dr <Plug>(ale_find_references)
nnoremap <F11> :ALEFix<cr>

nmap <silent> <leader>rr :Semshi rename<CR>
nmap <silent> <Tab> :Semshi goto name next<CR>
nmap <silent> <S-Tab> :Semshi goto name prev<CR>
nmap <silent> <leader>c :Semshi goto class next<CR>
nmap <silent> <leader>C :Semshi goto class prev<CR>
nmap <silent> <leader>f :Semshi goto function next<CR>
nmap <silent> <leader>F :Semshi goto function prev<CR>
nmap <silent> <leader>ee :Semshi error<CR>
nmap <silent> <leader>ge :Semshi goto error<CR>

" #####################
" ### OTHER PLUGINS ###
" #####################

let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,125,124,19]
nnoremap <F10> :SemanticHighlightToggle<cr>
" autocmd FileType * SemanticHighlightToggle

cmap w!! :w suda://%<CR>:e!<CR>

let g:signify_update_on_focusgained = 1
let g:vim_search_pulse_duration = 200
let g:rubycomplete_buffer_loading = 1
let g:rainbow_active = 1

au FileType spec map <buffer> <F5> <Plug>AddChangelogEntry
let spec_chglog_packager = "Mehdi Abaakouk <sileht@sileht.net>"

" ############
" ### Mail ###
" ############
let g:VimMailSpellLangs=['fr', 'en']
let g:VimMailClient="true"
let g:VimMailStartFlags="SA"
let g:VimMailContactSyncCmd="true"
let g:VimMailContactQueryCmd="/home/sileht/.env/bin/vim-mail-contact-query"
autocmd FileType mail setlocal completeopt+=preview

" ###################
" ### SPELL CHECK ###
" ###################
" Use en_us spell and completion per default for markdown and rst
autocmd FileType gitcommit,rst,mkd,markdown,jinja silent! call ToggleSpell()
autocmd FileType gitcommit,rst,mkd,markdown,jinja set complete+=kspell

map <F6> :w<CR>:!aspell -l en -c %<CR>:e %<CR>
map <F7> :w<CR>:!aspell -l fr -c %<CR>:e %<CR>
nmap <silent> <F8> :call ToggleSpell()<CR>

let b:myLang=0
let g:myLangList=["nospell", "en_us", "fr"]
function! ToggleSpell()
  let b:myLang=b:myLang+1
  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
  if b:myLang==0
    setlocal nospell
  else
    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
  endif
  echo "spell checking language:" g:myLangList[b:myLang]
endfunction

" #########################
" ### VARIOUS FUNCTIONS ###
" #########################
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {'backup': 'backupdir','views': 'viewdir', 'swap': 'directory' }

    " To specify a different directory in which to place the vimbackup,
    " vimviews, vimundo, and vimswap files/directories, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_consolidated_directory = <full path to desired directory>
    "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

function! LoadVirtualEnv()
if has('python')
python << pythoneof
import vim
import os

def load_flake8(path):
    for venv in (".tox/pep8", ".tox/linters", ".tox/lint"):
        venvdir = os.path.join(path, venv)
        if os.path.exists(venvdir):
            vim.command("let g:ale_python_flake8_executable = '%s/bin/flake8'" % venvdir)
            vim.command("let g:ale_fixers.python = ['black', 'isort']")
            return

def load_venv(path):
    for venv in (".tox/py38", ".tox/py37", ".tox/py27", "venv"):
        venvdir = os.path.join(path, venv)
        if os.path.exists(venvdir):
            vim.command("let g:ale_python_pyls_config.pyls.plugins.jedi.environment='%s'" % venvdir)
            vim.command("let $VIRTUAL_ENV='%s'" % venvdir)
            return

def is_source_root(path):
    for f in ("tox.ini", ".tox", "venv", ".git", ".hg"):
        if os.path.exists(os.path.join(path, f)):
            return True
    return False

current_path = os.path.abspath(vim.eval('getcwd()'))
home = os.path.abspath("~")
while True:
    if is_source_root(current_path):
        load_venv(current_path)
        load_flake8(current_path)
        break
    current_path = os.path.abspath(os.path.join(current_path, ".."))
    if current_path == home or current_path == "/":
        break

pythoneof
endif
endfunction


packloadall
silent! helptags ALL
