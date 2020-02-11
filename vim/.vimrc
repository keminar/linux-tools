"语法高亮
syntax on
"用F12切换插入与粘贴模式
set pastetoggle=<f12>
"设置（软）制表符宽度为4：
set tabstop=4
set softtabstop=4
"设置缩进的空格数为4
set shiftwidth=4
"设置自动缩进：即每行的缩进值与上一行相等；使用noautoindent取消设置：
set autoindent
set copyindent
"括号匹配
set showmatch
"搜索高亮
set hls
"设置backspace键可以刪除任意值
set bs=2
"新建文件默认字符集
set enc=utf8
"可以查看的文件字符集,会自动转换编码
set fencs=ucs-bom,utf8,chinese
"不产生swap文件
set noswapfile
set nobackup
set nowritebackup
"设置使用C/C++语言的自动缩进方式：
autocmd FileType c,cpp set cindent
"python替掉tab
autocmd BufWritePre,FileWritePre *.py set expandtab | %retab!

autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class 
autocmd FileType python set omnifunc=pythoncomplete#Complete

"自动打开
let g:nerdtree_tabs_open_on_console_startup=1
"快捷键
map <C-n> :NERDTreeTabsToggle<CR>
"自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"右边显示
let g:NERDTreeWinPos="right"

"显示TAB键
set list
set listchars=tab:>-,trail:-
" 增强模式中的命令行自动完成操作
set wildmenu
" 探测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on

" TAB替换为空格
map <F10> :set expandtab <CR> :%retab! <CR>
" 空格替换为TAB
map <F11> :set noexpandtab <CR> :%retab! <CR>
" 去空格
map <F8> :set list <CR>
map <F7> :set nolist <CR>
map <F9> :%s/\s\+$// <CR>

" go to prev tab 
map <S-H> gT
" go to next tab
map <S-L> gt
" new tab
map <C-t><C-t> :tabnew<CR>
" close tab
map <C-t><C-w> :tabclose<CR>


