"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Last Update: 2020-11-11
" By: mrwlwan@gmail.com
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
" }

" Environment { # 系统环境
    " Identify platform { # 操作系统识别
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " 自定义变量 {
        let g:wan_vimrc_filename = 'vimrc'
        let g:wan_vimrc_path = $VIM . '/' . g:wan_vimrc_filename
        let g:wan_vimfiles_path = $VIM . '/.vim'
        let g:wan_bundle_path = g:wan_vimfiles_path . '/bundle'
        let g:wan_backupdir_path = g:wan_vimfiles_path .  '/vimbackup'
        let g:wan_viewdir_path = g:wan_vimfiles_path . '/vimview'
        let g:wan_swapdir_path = g:wan_vimfiles_path . '/vimswap'
        let g:wan_undodir_path = g:wan_vimfiles_path . '/vimundo'
        let g:wan_strip_trailing_whitespace = 1
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible { # Windows 系统兼容设置
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization across (heterogeneous) systems easier.
        if WINDOWS()
            " # 添加 $VIM/.vim
            set runtimepath=$VIM/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim,$HOME/.vim/after
            " Be nice and check for multi_byte even if the config requires multi_byte support most of the time
            if has("multi_byte")
                " Windows cmd.exe still uses cp850. If Windows ever moved to Powershell as the primary terminal, this would be utf-8
                set termencoding=cp850
                " Let Vim use utf-8 internally, because many scripts require this
                set encoding=utf-8
                setglobal fileencoding=utf-8
                " Windows has traditionally used cp1252, so it's probably wise to fallback into cp1252 instead of eg. iso-8859-15.
                " Newer Windows files might contain utf-8 or utf-16 LE so we might want to try them first.
                set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
            endif
        endif
    " }

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

    " Add an UnBundle command {
        function! UnBundle(arg, ...)
          let bundle = vundle#config#init_bundle(a:arg, a:000)
          call filter(g:vundle#bundles, 'v:val["name_spec"] != "' . a:arg . '"')
        endfunction
        com! -nargs=+         UnBundle call UnBundle(<args>)
    " }
" }

" Bundles { # 安装插件
    filetype off
    set rtp+=$VIM/.vim/bundle/Vundle.vim
    call vundle#begin(g:wan_bundle_path)

    " Deps { # 安装插件信赖库
        Plugin 'VundleVim/Vundle.vim'
        " Plugin 'MarcWeber/vim-addon-mw-utils'             " # vim-snimate 依赖库
        " Plugin 'tomtom/tlib_vim'                          " # vim-snimate 依赖库
        Plugin 'mattn/webapi-vim'                           " # webapi, 其它插件用到
        Plugin 'kana/vim-textobj-user'                      " # 创建文本对象, 部分插件依赖它
        Plugin 'kana/vim-textobj-indent'                    " # 创建文本对象的扩充功能
        if executable('ag')
            Plugin 'mileszs/ack.vim'        " Perl 支持
            let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
        elseif executable('ack-grep')
            let g:ackprg="ack-grep -H --nocolor --nogroup --column"
            Plugin 'mileszs/ack.vim'
        elseif executable('ack')
            Plugin 'mileszs/ack.vim'
        endif
    " }

    " General { # 通用
        Plugin 'scrooloose/nerdtree'                        " # 目录树
        Plugin 'altercation/vim-colors-solarized'           " # Solarized 主题
        Plugin 'spf13/vim-colors'                           " # 多个配色方案
        Plugin 'tpope/vim-surround'                         " # 高效操作与括号、引号或html、xml标签相关的配对符号(surrounding)
        Plugin 'tpope/vim-repeat'                           " # .键可重复一个插件的操作
        Plugin 'rhysd/conflict-marker.vim'                  " # 帮助文件合并冲突处理
        Plugin 'jiangmiao/auto-pairs'                       " # Insert or delete brackets, parens, quotes in pair
        Plugin 'ctrlpvim/ctrlp.vim'                         " # 支持对文件, 缓冲区, MRU(Most Recently Used)文件和标签进行模糊搜索/查找的 Vim 插件, 也支持通过正则表达式搜索
        Plugin 'tacahiroy/ctrlp-funky'                      " # 方法函数导航器, 不依赖 ctag
        Plugin 'terryma/vim-multiple-cursors'               " # 多重选取, 一处编辑, 多处更改
        Plugin 'vim-scripts/sessionman.vim'                 " # 会话管理器
        Plugin 'matchit.zip'                                " # 成对标签跳转. vim 的 % 会自动跳转到匹配的()[]{}<>等符号, 但是在编辑 html 和 xml 的时候, 可能需要在配对标签直接跳转, 这个插件扩展实现了这个功能.
        " Plugin 'Lokaltog/powerline', {'rtp':'/powerline/bindings/vim'}    " # 暂时使用更轻量的 airline
        " Plugin 'Lokaltog/vim-powerline'                                   " # 旧版本的 powerline, 暂时使用更轻量的 airline
        Plugin 'vim-airline/vim-airline'
        Plugin 'vim-airline/vim-airline-themes'
        " Plugin 'powerline/fonts'
        Plugin 'bling/vim-bufferline'                       " # 状态栏显示 buffer
        Plugin 'easymotion/vim-easymotion'                  " # 快速跳转
        Plugin 'jistr/vim-nerdtree-tabs'                    " # NERDTree 目录树增强
        " Plugin 'flazz/vim-colorschemes'                   " # 配色方案
        Plugin 'mbbill/undotree'                            " # 可视化 undo 历史
        Plugin 'nathanaelkane/vim-indent-guides'            " # 可视化显示缩进提示线
        Plugin 'vim-scripts/restore_view.vim'               " # view
        " Plugin 'mhinz/vim-signify'                          " # 文件差异高亮展示的Vim版本控制插件
        Plugin 'tpope/vim-abolish.git'                      " # 替换加强版, 可实现交换功能, 变量名驼峰统一之类
        Plugin 'osyo-manga/vim-over'                        " # 替换高亮预览
        Plugin 'gcmt/wildfire.vim'                          " # 选择成对标签里的内容
    " }

    " General Programming {
        " Pick one of the checksyntax, jslint, or syntastic
        " Plugin 'scrooloose/syntastic'                       " # 语法检查
        " Plugin 'tpope/vim-fugitive'                         " # git 命令
        " Plugin 'mattn/gist-vim'                             " # git 的 gist 功能
        Plugin 'scrooloose/nerdcommenter'                   " # 注释
        " Plugin 'tpope/vim-commentary'                       " # 另一个注释
        Plugin 'godlygeek/tabular'                          " # 文本对齐
        Plugin 'luochen1990/rainbow'                        " # 将不同层次的括号高亮为不同的颜色
    " }

    " Snippets & AutoComplete {                                 " # 自动补全
        Plugin 'SirVer/ultisnips'
        Plugin 'honza/vim-snippets'
        " Plugin 'drmingdrmer/xptemplate'                     " * 比 snippets 好用
        Plugin 'ervandew/supertab'                          " *
    " }

    " Python {
        " Pick either python-mode or pyflakes & pydoc
        "Plugin 'klen/python-mode'                          " # 将 vim 变成 Python IDE
        Plugin 'yssource/python.vim'                        " # Python 快捷操作
        Plugin 'python_match.vim'                           " # Extend the % motion and define g%, [%, and ]% motions for Python files
        " Plugin 'pythoncomplete'                             " # This is the pythoncomplete omni-completion script shipped with vim 7+
    " }

    " HTML {
        Plugin 'heracek/HTML-AutoCloseTag'                    " # Automatically closes HTML tag once you finish typing it with >
        Plugin 'hail2u/vim-css3-syntax'                     " # CSS3 语法高亮
        Plugin 'gorodinskiy/vim-coloresque'                 " # 直观的颜色代码显示
        Plugin 'tpope/vim-haml'                             " # 使 vim 添加对 Haml, Sass, SCSS 的支持
        Plugin 'mattn/emmet-vim'                            " # 项目原先叫 Zen Coding, 非常方便快捷的插件
    " }

    " Javascript {
        Plugin 'elzr/vim-json'                              " # json 语法高亮
        Plugin 'groenewege/vim-less'                        " # less 语法高亮
        Plugin 'pangloss/vim-javascript'                    " # javascript 语法高亮和增强缩进
        Plugin 'briancollins/vim-jst'                       " # JST 语法高亮和增强缩进
        Plugin 'kchmck/vim-coffee-script'                   " # 使 Vim 添加对 coffee 的支持, 如语法高亮, 缩进, 编译等等
    " }

    " Misc {
        Plugin 'rust-lang/rust.vim'                         " # 对 RUST 的支持
        Plugin 'tpope/vim-markdown'                         " # 对 markdown 的支持
        Plugin 'spf13/vim-preview'                          " # 预览 markup 类型的文件(markdown, rdoc, textile, html)
        " Plugin 'tpope/vim-cucumber'                         " # 对 cucumber 的支持
        " Plugin 'quentindecock/vim-cucumber-align-pipes'     " # 对cucumber 的支持, 代码对齐
        " Plugin 'cespare/vim-toml'                           " # 对 toml 的支持
        " Plugin 'saltstack/salt-vim'                         " # 对 salt 的支持
    " }

    call vundle#end()
" }

" General { # 通用设置
    set background=dark         " Assume a dark background # 设置黑背景色

    " Allow to trigger background # 转换深浅背景色
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == 'dark'
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>bg :call ToggleBG()<CR>

    if !has('gui')
        set term=$TERM          " Make arrow and other keys work
    endif
    filetype plugin indent on   " Automatically detect file types. # 打开文件类型识别
    syntax on                   " Syntax highlighting # 语法高亮显示
    set mouse=a                 " Automatically enable mouse usage # 启用鼠标复制模式
    set mousehide               " Hide the mouse cursor while typing # 打字时隐藏鼠标
    scriptencoding utf-8        " 如果在 .vimrc 里设置 ' set encoding=?' 选项, :scriptencoding  必须在放在它后面

    "if has('clipboard')         " 剪贴板设置
        "if has('unnamedplus')  " When possible use + register for copy-paste
            "set clipboard=unnamed,unnamedplus
        "else         " On mac and Windows, use * register for copy-paste
            "set clipboard=unnamed
        "endif
    "endif
    source $VIMRUNTIME/mswin.vim " # MS-Windows 操作方式的剪贴板 Ctrl+c, Ctrl+v
    " Most prefer to automatically switch to the current file directory when a new buffer is opened. Always switch to the current file directory
    " # 改变当前目录为打开文件的目录
    autocmd BufEnter * if bufname('') !~ '^\[A-Za-z0-9\]*://' | lcd %:p:h | endif

    " set autowrite                     " Automatically write a file when leaving a modified buffer # 自动保存, 默认禁止
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    " set spell                           " Spell checking on # 拼写检查
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator # 用于 * 搜索词, 设定". # -"不属于词的一部分
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we set it to the first line when editing a git commit message
    " # gitcommit 光标位置设置
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session. Restore cursor to file position in previous editing session
    " # 打开文件时的鼠标位置
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

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile            " So is persistent undo ...
            set undolevels=1000     " Maximum number of changes that can be undone
            set undoreload=10000    " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your
        " Add exclusions to mkview and loadview
        " eg: *.*, svn-commit.tmp
        let g:skipview_files = [
            \ '\[example pattern\]'
            \ ]
    " }
" }

" Vim UI { # Vim 界面设置
    " 设置 solarized colorscheme
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    let g:solarized_contrast="normal"
    let g:solarized_visibility="normal"
    color solarized                 " Load a colorscheme

    set showtabline=2               " 总是显示标签栏
    set tabpagemax=15               " Only show 15 tabs # 显示的最大标签数
    set showmode                    " Display the current mode # 在状态栏显示当前模式
    set cursorline                  " Highlight current line # 高亮显示鼠标所在行
    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number
    set scrolloff=5                 " 缩写so, 保持在光标上下最少行数

    if has('cmdline_info')
        set ruler                   " Show the ruler # 状态栏显示行号
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and # 在状态栏显示输入的命令
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')            " 状态栏设置
        set laststatus=2 " # 总是显示状态栏
        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        " if !exists('g:override_spf13_bundles')
            " set statusline+=%{fugitive#statusline()} " Git Hotness
        " endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies # 修复非兼容模式下退格和删除键的问题
    set linespace=0                 " No extra spaces between rows # 行距
    set number                      " Line numbers on # 显示行号
    set showmatch                   " Show matching brackets/parenthesis # 当输入一个左括号时显示自动匹配右括号
    set incsearch                   " Find as you type search # 即时搜索(即时高亮显示输入的搜索内容)
    set hlsearch                    " Highlight search terms # 搜索词高亮显示
    set winminheight=0              " Windows can be 0 line high # 窗口最小高度
    set ignorecase                  " Case insensitive search # 搜索忽略大小写
    set smartcase                   " Case sensitive when uc present # 搜索智能忽略大小写
    set wildmenu                    " Show list instead of just completing # 启用增强模式的命令行自动补全
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all. # 自动实例模式
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too  # 默认情况下, 在 VIM 中当光标移到一行最左边的时候, 我们继续按左键, 光标不能回到上一行的最右边. 同样地,光标到了一行最右边的时候, 我们不能通过继续按右跳到下一行的最左边. 但是, 通过设置 whichwrap 我们可以对一部分按键开启这项功能
    set scrolljump=5                " Lines to scroll when cursor leaves screen. # 鼠标点击右边滚动条时滚动的行数
    set scrolloff=5                 " Minimum lines to keep above and below cursor # 缩写为 so. 滚动时原来内容保留的最小行数
    set foldenable                  " Auto fold code # 启用自动折叠
    set list                        " # 显示非可见字符
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace # 指定高亮显示部分非可见字符
" }

" Formatting { # 显示格式设置
    " set nowrap                      " Do not wrap long lines # 禁止自动折行
    set textwidth=0                 " 缩写 tw, 随窗口宽度自动折行
    set wrap                        " 自动折行
    set autoindent                  " Indent at the same level of the previous line # 开启自动缩进
    set shiftwidth=4                " Use indents of 4 spaces # 缩进空格数
    set expandtab                   " Tabs are spaces, not tabs # 使用空格而非制表符
    set tabstop=4                   " An indentation every four columns # 设定1个制表符为4个空格
    set softtabstop=4               " Let backspace delete indent # 可以让退格键1次直接删除4个空格
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J) # 用<Ctrl> + j 连接两行时中间不插入2个空格
    set splitright                  " Puts new vsplit windows to the right of the current # 将新开的 split 窗口放在右边
    set splitbelow                  " Puts new split windows to the bottom of the current # 将新开的 split 窗口放在下边
    "set matchpairs+=<:>             " Match, to be used with % # 指定显示匹配所用的字符
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes) # 处理粘贴时的缩进问题. 设置<F12>开关
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    " To disable the stripping of whitespace, add the following to your
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if g:wan_strip_trailing_whitespace | call StripTrailingWhitespace() | endif
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell
" }

" Key (re)Mappings { # 快捷键设置
    " The default leader is '\', but many people prefer ',' as it's in a standard location.
    " # 设置 leader 键
    let mapleader = ','
    " let maplocalleader = '_'
    let maplocalleader = ','

    " The default mappings for editing vim configuration(vimrc) are <leader>e respectively.
    " map <leader>e :e! $VIM/vimrc<cr>
    execute "map <leader>e :e! " . g:wan_vimrc_path . "<cr>"
    execute "autocmd! bufwritepost " . g:wan_vimrc_filename . " source %"

    " Easier moving in tabs and windows. The lines conflict with the default digraph mapping of <C-K>
    " # 标签和窗口的移动选择操作
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    " # 允许在一行(折行)中上下移动光标
    noremap j gj
    noremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the presence of `:set wrap`, and relative to line for `:set nowrap`. Default vim behaviour is to act relative to text line in both cases.
    " # $, 0, ^, <home>, <end> 键的设置
    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction
    " Map g* keys in Normal, Operator-pending, and Visual+select
    "noremap $ :call WrapRelativeMotion("$")<CR>
    "noremap <End> :call WrapRelativeMotion("$")<CR>
    "noremap 0 :call WrapRelativeMotion("0")<CR>
    "noremap <Home> :call WrapRelativeMotion("0")<CR>
    "noremap ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    "onoremap $ v:call WrapRelativeMotion("$")<CR>
    "onoremap <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    "vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    "vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    "vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    "vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    "vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>

    " The following two lines conflict with moving to top and bottom of the screen
    " # 标签快速左右选择
    " map <S-H> gT
    " map <S-L> gt

    " Stupid shift key fixes # shift 键修复
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif
    cmap Tabe tabe

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    " # Y 键的粘贴操作
    nnoremap Y y$

    " Code folding options # 折叠 foldlevel 快捷键
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current search results.
    " # 清除高亮显示
    " nmap <silent> <leader>/ :nohlsearch<CR>
    " # 开关高亮显示
    nmap <silent> <leader>/ :set invhlsearch<CR>

    " Find merge conflict markers # 冲突搜索
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Change Working Directory to that of the current file. # 改变工作目录为当前文件的目录
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode) # 未知
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!) # . 键(重复)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file. # 保存
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode # 不同方式的打开文件(同一窗口, 新建分割窗口, 新建标签)
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size # 改变所有窗口相同大小
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    " # 关键字互动跳转
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling # 水平滚动
    map zl zL
    map zh zH

    " Easier formatting # 格式化
    nnoremap <silent> <leader>q gwip

    " FIXME: Revert this f70be548 # 修复 <F11> 全屏键
    " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
" }

" Plugins { # 插件
    " General {
        " NERDTRee 相关设置
        let g:NERDShutUp=1
        let g:nerdtree_tabs_open_on_gui_startup=0       "启动 vim 时默认不打开 NERDTree
        " matchit.zip 相关设置
        let b:match_ignorecase = 1
        " NERDCommenter 相关设置
        let g:NERDSpaceDelims = 1                       " 在注释标识符后添加1个空格
    " }

    " AutoCloseTag { # HTML
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " Tabularize {
        " if isdirectory(expand(g:wan_bundle_path . "/tabular"))
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        " endif
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        " if isdirectory(expand(g:wan_bundle_path . "/sessionman.vim/"))
            nmap <leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
            nmap <leader>sc :SessionClose<CR>
        " endif
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0
    " }

    " ctrlp {
        " if isdirectory(expand(g:wan_bundle_path . "/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            nnoremap <silent> <D-t> :CtrlP<CR>
            nnoremap <silent> <D-r> :CtrlPMRU<CR>
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            " On Windows use "dir" as fallback command.
            elseif WINDOWS()
                let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            if exists("g:ctrlp_user_command")
                unlet g:ctrlp_user_command
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }

            " if isdirectory(expand($VIM . "/.vim/bundle/ctrlp-funky/"))
                " CtrlP extensions
                let g:ctrlp_extensions = ['funky']

                "funky
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            " endif
        " endif
    "}

    " Rainbow {
        " if isdirectory(expand(g:wan_bundle_path . "/rainbow/"))
            let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
        " endif
    "}

    " FIXME: Isn't this for Syntastic to handle? Haskell post write lint and check with ghcmod $ `cabal install ghcmod` if missing and ensure ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif

    " UndoTree {
        " if isdirectory(expand(g:wan_bundle_path . "/undotree/"))
            nnoremap <Leader>u :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        " endif
    " }

    " indent_guides { # 可视化缩进
        " if isdirectory(expand(g:wan_bundle_path . "/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        " endif
    " }

    " Wildfire { # 选择成对标签里的内容
        let g:wildfire_objects = {
                    \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                    \ "html,xml" : ["at"],
                    \ }
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        " if isdirectory(expand(g:wan_bundle_path . "/vim-airline-themes/"))
            let g:airline_theme = 'solarized'
            " Use the default set of separators with a few customizations
            let g:airline_left_sep='›'  " Slightly fancier than '>'
            let g:airline_right_sep='‹' " Slightly fancier than '<'
        " endif
    " }

    " ultisnips {
        let g:UltiSnipsExpandTrigger="<C-F10>"
        let g:UltiSnipsJumpForwardTrigger="<C-F12>"
        let g:UltiSnipsJumpBackwardTrigger="<C-F11>"
    " }

    " auto-pairs {
        let g:AutoPairsFlyMode = 0
        let g:AutoPairsShortcutFastWrap = "<C-F8>"
        let g:AutoPairsShortcutJump = "<C-F9>"
    " }

" }

" GUI Settings {
    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=m           " Remove the menu
        set guioptions-=T           " Remove the toolbar
        " if &lines<25                 " 避免 reload vimrc 重设窗口高度
        if !exists('g:wan_vimrc_loaded')
            set lines=40             " 40 lines of text instead of 24
        endif
        if LINUX() && has("gui_running")
            set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
        elseif OSX() && has("gui_running")
            set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
        elseif WINDOWS() && has("gui_running")
            set guifont=Andale_Mono:h14,Menlo:h14,Consolas:h14,Courier_New:h14
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif
" }

" Functions {
    " Initialize directories {
    function! InitializeDirectories()
        let &backupdir = g:wan_backupdir_path
        let &viewdir = g:wan_viewdir_path
        let &directory = g:wan_swapdir_path
        if has('persistent_undo')
            let &undodir = g:wan_undodir_path
        endif
    endfunction
    call InitializeDirectories()
    " }

    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    " Strip whitespace { # 删除无用的空白字符
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }
" }

let g:wan_vimrc_loaded = 1
