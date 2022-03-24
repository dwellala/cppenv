# https://codevion.github.io/#!vim/coc.md

FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

LABEL description="dstenv" 

# install build dependencies 
RUN apt-get update && apt-get install -y g++ gcc cmake neovim apt-utils curl git ccls tmux sudo
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
" > ~/.config/nvim/init.vim 

RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

RUN echo "\
call plug#begin() \n\
Plug 'vimwiki/vimwiki'  \n\
Plug 'tbabej/taskwiki'  \n\
Plug 'plasticboy/vim-markdown'  \n\
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
" > ~/.config/coc.json

RUN echo "https://github.com/neoclide/coc.nvim#example-vim-configuration \n\
" >> ~/.config/coc.json

