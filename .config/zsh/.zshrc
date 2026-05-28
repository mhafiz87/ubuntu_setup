DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

SPACESHIP_PROMPT_ASYNC=true
SPACESHIP_PROMPT_ADD_NEWLINE=true

ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_VI_VISUAL_ESCAPE_BINDKEY=jk
ZVM_VI_OPPEND_ESCAPE_BINDKEY=jk
ZVM_VI_SURROUND_BINDKEY=s-prefix

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$PATH:/opt/neovim/bin

bat_f() {
  if [ $# -eq 0 ]; then
      whereis batcat
  else
      batcat "$@"
fi
}
alias -g bat='bat_f'
