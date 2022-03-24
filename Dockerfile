# https://codevion.github.io/#!vim/coc.md

FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

LABEL description="dstenv" 

# install build dependencies 
RUN apt-get update && apt-get install -y g++ gcc cmake neovim apt-utils curl git ccls sudo
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt -y install nodejs

RUN mkdir -p ~/.config/nvim/
RUN touch ~/.config/nvim/init.vim
RUN echo "\
set nocompatible            \" disable compatibility to old-time vi \n\
set showmatch               \" show matching  \n\
set ignorecase              \" case insensitive \n\
set mouse=v                 \" middle-click paste with \n\
set hlsearch                \" highlight search \n\
set incsearch               \" incremental search \n\
set tabstop=4               \" number of columns occupied by a tab \n\
set softtabstop=4           \" see multiple spaces as tabstops so <BS> does the right thing \n\
set expandtab               \" converts tabs to white space \n\
set shiftwidth=4            \" width for autoindents \n\
set autoindent              \" indent a new line the same amount as the line just typed \n\
set number                  \" add line numbers \n\
set wildmode=longest,list   \" get bash-like tab completions \n\
set cc=120                  \" set an 120 column border for good coding style \n\
filetype plugin indent on   \"allow auto-indenting depending on file type \n\
syntax on                   \" syntax highlighting \n\
set mouse=a                 \" enable mouse click \n\
set clipboard=unnamedplus   \" using system clipboard \n\
filetype plugin on          \n\
set cursorline              \" highlight current cursorline \n\
set ttyfast                 \" Speed up scrolling in Vim \n\
set encoding=utf-8          \n\
set hidden                  \n\
set nobackup                \n\
set nowritebackup           \n\
set cmdheight=2             \n\
set updatetime=300          \n\
set shortmess+=c            \n\
if has(\"nvim-0.5.0\") || has(\"patch-8.1.1564\")   \n\
  set signcolumn=number                             \n\
else                                                \n\
  set signcolumn=yes                                \n\
endif                                               \n\
\" Use tab for trigger completion with characters ahead and navigate.               \n\
\" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by        \n\
\" other plugin before putting this into your config.                               \n\
inoremap <silent><expr> <TAB>                                                       \n\
      \ pumvisible() ? \"\<C-n>\" :                                                 \n\
      \ <SID>check_back_space() ? \"\<TAB>\" :                                      \n\
      \ coc#refresh()                                                               \n\
inoremap <expr><S-TAB> pumvisible() ? \"\<C-p>\" : \"\<C-h>\"                       \n\
                                                                                    \n\
function! s:check_back_space() abort                                                \n\
  let col = col('.') - 1                                                            \n\
  return !col || getline('.')[col - 1]  =~# '\s'                                    \n\
endfunction                                                                         \n\
                                                                                    \n\
\" Use <c-space> to trigger completion.                                             \n\
if has('nvim')                                                                      \n\
  inoremap <silent><expr> <c-space> coc#refresh()                                   \n\
else                                                                                \n\
  inoremap <silent><expr> <c-@> coc#refresh()                                       \n\
endif                                                                               \n\
                                                                                    \n\
\" Make <CR> auto-select the first completion item and notify coc.nvim to           \n\
\" format on enter, <cr> could be remapped by other vim plugin                      \n\
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()                   \n\
                              \: \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>\"         \n\
                                                                                    \n\
\" Use `[g` and `]g` to navigate diagnostics                                        \n\
\" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list. \n\
nmap <silent> [g <Plug>(coc-diagnostic-prev)                                        \n\
nmap <silent> ]g <Plug>(coc-diagnostic-next)                                        \n\
                                                                                    \n\
\" GoTo code navigation.                                                            \n\
nmap <silent> gd <Plug>(coc-definition)                                             \n\
nmap <silent> gy <Plug>(coc-type-definition)                                        \n\
nmap <silent> gi <Plug>(coc-implementation)                                         \n\
nmap <silent> gr <Plug>(coc-references)                                             \n\
                                                                                    \n\
\" Use K to show documentation in preview window.                                   \n\
nnoremap <silent> K :call <SID>show_documentation()<CR>                             \n\
                                                                                    \n\
function! s:show_documentation()                                                    \n\
  if (index(['vim','help'], &filetype) >= 0)                                        \n\
    execute 'h '.expand('<cword>')                                                  \n\
  elseif (coc#rpc#ready())                                                          \n\
    call CocActionAsync('doHover')                                                  \n\
  else                                                                              \n\
    execute '!' . &keywordprg . \" \" . expand('<cword>')                           \n\
  endif                                                                             \n\
endfunction                                                                         \n\
                                                                                    \n\
\" Highlight the symbol and its references when holding the cursor.                 \n\
autocmd CursorHold * silent call CocActionAsync('highlight')                        \n\
                                                                                    \n\
\" Symbol renaming.                                                                 \n\
nmap <leader>rn <Plug>(coc-rename)                                                  \n\
                                                                                    \n\
\" Formatting selected code.                                                        \n\
xmap <leader>f  <Plug>(coc-format-selected)                                         \n\
nmap <leader>f  <Plug>(coc-format-selected)                                         \n\
                                                                                    \n\
augroup mygroup                                                                     \n\
  autocmd!                                                                          \n\
  \" Setup formatexpr specified filetype(s).                                        \n\
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')      \n\
  \" Update signature help on jump placeholder.                                     \n\
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')          \n\
augroup end                                                                         \n\
                                                                                    \n\
\" Applying codeAction to the selected region.                                      \n\
\" Example: `<leader>aap` for current paragraph                                     \n\
xmap <leader>a  <Plug>(coc-codeaction-selected)                                     \n\
nmap <leader>a  <Plug>(coc-codeaction-selected)                                     \n\
                                                                                    \n\
\" Remap keys for applying codeAction to the current buffer.                        \n\
nmap <leader>ac  <Plug>(coc-codeaction)                                             \n\
\" Apply AutoFix to problem on the current line.                                    \n\
nmap <leader>qf  <Plug>(coc-fix-current)                                            \n\
                                                                                    \n\
\" Run the Code Lens action on the current line.                                    \n\
nmap <leader>cl  <Plug>(coc-codelens-action)                                        \n\
                                                                                    \n\
\" Map function and class text objects                                              \n\
\" NOTE: Requires 'textDocument.documentSymbol' support from the language server.   \n\
xmap if <Plug>(coc-funcobj-i)                                                       \n\
omap if <Plug>(coc-funcobj-i)                                                       \n\
xmap af <Plug>(coc-funcobj-a)                                                       \n\
omap af <Plug>(coc-funcobj-a)                                                       \n\
xmap ic <Plug>(coc-classobj-i)                                                      \n\
omap ic <Plug>(coc-classobj-i)                                                      \n\
xmap ac <Plug>(coc-classobj-a)                                                      \n\
omap ac <Plug>(coc-classobj-a)                                                      \n\
                                                                                    \n\
\" Remap <C-f> and <C-b> for scroll float windows/popups.                           \n\
if has('nvim-0.4.0') || has('patch-8.2.0750')                                       \n\
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : \"\<C-f>\"                   \n\
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : \"\<C-b>\"                   \n\
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? \"\<c-r>=coc#float#scroll(1)\<cr>\" : \"\<Right>\" \n\
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? \"\<c-r>=coc#float#scroll(0)\<cr>\" : \"\<Left>\"  \n\
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : \"\<C-f>\"                   \n\
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : \"\<C-b>\"                   \n\
endif                                                                               \n\
                                                                                    \n\
\" Use CTRL-S for selections ranges.                                                \n\
\" Requires 'textDocument/selectionRange' support of language server.               \n\
nmap <silent> <C-s> <Plug>(coc-range-select)                                        \n\
xmap <silent> <C-s> <Plug>(coc-range-select)                                        \n\
                                                                                    \n\
\" Add `:Format` command to format current buffer.                                  \n\
command! -nargs=0 Format :call CocActionAsync('format')                             \n\
                                                                                    \n\
\" Add `:Fold` command to fold current buffer.                                      \n\
command! -nargs=? Fold :call     CocAction('fold', <f-args>)                        \n\
                                                                                    \n\
\" Add `:OR` command for organize imports of the current buffer.                    \n\
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')   \n\
                                                                                    \n\
\" Add (Neo)Vim's native statusline support.                                        \n\
\" NOTE: Please see `:h coc-status` for integrations with external plugins that     \n\
\" provide custom statusline: lightline.vim, vim-airline.                           \n\
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}                 \n\
                                                                                    \n\
\" Mappings for CoCList                                                             \n\
\" Show all diagnostics.                                                            \n\
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>                   \n\
\" Manage extensions.                                                               \n\
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>                    \n\
\" Show commands.                                                                   \n\
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>                      \n\
\" Find symbol of current document.                                                 \n\
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>                       \n\
\" Search workspace symbols.                                                        \n\
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>                    \n\
\" Do default action for next item.                                                 \n\
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>                               \n\
\" Do default action for previous item.                                             \n\
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>                               \n\
\" Resume latest coc list.                                                          \n\
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>                         \n\
" > ~/.config/nvim/init.vim 

RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

RUN echo "\
call plug#begin() \n\
Plug 'vimwiki/vimwiki' \n\
Plug 'tbabej/taskwiki'  \n\
Plug 'plasticboy/vim-markdown'        \n\
Plug 'tomasr/molokai'      \n\
Plug 'justinmk/vim-sneak'     \n\
Plug 'junegunn/fzf', { 'do': { ->fzf#install() } } \n\
Plug 'junegunn/fzf.vim'      \n\
Plug 'mhinz/vim-startify'      \n\
Plug 'liuchengxu/vista.vim'      \n\
Plug 'itchyny/lightline.vim'      \n\
Plug 'neoclide/coc.nvim', {'branch': 'release'}    \n\
call plug#end() \n\
" >> ~/.config/nvim/init.vim

RUN echo "\
autocmd FileType vim setlocal foldmethod=marker \n\
" >> ~/.config/nvim/init.vim

RUN vim +'PlugInstall --sync' +qa
RUN vim +'CocConfig --sync' +qa

RUN echo "\
{\n\
\"languageserver\": { \n\
  \"ccls\": { \n\
    \"command\": \"ccls\", \n\
    \"filetypes\": [\"c\", \"cc\", \"cpp\", \"c++\", \"objc\", \"objcpp\"], \n\
    \"rootPatterns\": [\".ccls\", \"compile_commands.json\", \".git/\", \".hg/\"], \n\
    \"initializationOptions\": { \n\
        \"cache\": { \n\
          \"directory\": \"/tmp/ccls\" \n\
        } \n\
      } \n\
  } \n\
} \n\
} \n\
" > ~/.config/coc/coc-settings.json

