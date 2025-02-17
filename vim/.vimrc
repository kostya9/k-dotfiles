" Fix annoying error bells
set visualbell
set noerrorbells 

set relativenumber
set nu

set scrolloff=8 " keep some lines before and after the cursor visible

set signcolumn=yes
set isfname+=@-@

" integrate with system clipboard
set clipboard+=unnamed

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :nohlsearch<CR><CR>
xnoremap <silent> <CR> :nohlsearch<CR><CR>

let mapleader = " "

" Highlights on search typing
set incsearch
" Highlights on search
set hls
" ignore case in search patterns
set ignorecase                    
" searches wrap around the end of the file
set wrapscan
" keep x lines of command line history
set history=10000                 

nnoremap <c-p> :action Find

nnoremap gd :action GotoDeclaration<CR>
nnoremap gi :action GotoImplementation<CR>
nnoremap gu :action ShowUsages<CR>

nnoremap <c-o> :action Back<cr>
nnoremap <c-i> :action Forward<cr>
nnoremap <K> :action QuickJavaDoc<cr>

nmap <leader>l :action NextTab<CR>
nmap <leader>h :action PreviousTab<CR>

nmap <C-p> :action ParameterInfo<CR>
imap <C-p> <C-o>:action ParameterInfo<CR>

nmap <leader>rr :action RenameElement<CR>
vmap <leader>rem :action ExtractMethod<CR>
nmap <leader>rem :action ExtractMethod<CR>
nmap <leader>roi :action OptimizeImports<CR>
nmap <leader>f :action ReformatCode<CR>
nmap <leader>rm :action Move<CR>

nmap > :action MoveElementRight<CR>
nmap < :action MoveElementLeft<CR>

" don't lose selection when indenting
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" // searches for current selected string
vnoremap // y/<C-R>"<CR>N

" Move lines around
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" do not overwrite copy register on paste
" set ReplaceWithRegister
xmap p gr

