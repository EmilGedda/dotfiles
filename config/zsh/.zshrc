if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
alias vim=nvim
alias vi=nvim
alias openhattis='hattis -c ~/.config/hattis/openkattisrc -f $PWD(:t:l:gs/ //:gs/-/)'
alias dmesg=dmesg -L=always

export EDITOR=nvim
export PAGER=less
export FONTCONFIG_PATH=/etc/fonts

# Customize to your needs...
# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd
unsetopt beep
unsetopt correct_all
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/emil/.config/zsh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz promptinit
promptinit

function silence {
  eval "$*" &>/dev/null
}

function prepend-sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"; CURSOR+=5
  fi
}

function nowrap {
    setterm -linewrap off
    eval "$@"
    setterm -linewrap on
}

zle -N prepend-sudo
bindkey "^[s" prepend-sudo

#bindkey "^[^[[C" forward-word     # Ctrl+right  => forward word
#bindkey "^[0;d" backward-word    # Ctrl+left   => backward word

bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

# Enforce default grep colos
export GREP_COLOR="01;31"
export GREP_COLORS="mt=$GREP_COLOR"

export LESSHISTSIZE=0
export LESSHISTFILE=/dev/null
export XDG_CACHE_DIR="$HOME/.cache"
export XAUTHORITY="$XDG_CONFIG_HOME/X11/Xauthority"

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.cabal/bin