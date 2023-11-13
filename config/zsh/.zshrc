if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

alias su='su -l'
alias vim=nvim
alias vi=nvim
alias docker=podman
alias openhattis='hattis -c ~/.config/hattis/openkattisrc -f $PWD(:t:l:gs/ //:gs/-/)'
alias dmesg=dmesg -L=always

export EDITOR=nvim
export PAGER=less
export FONTCONFIG_PATH=/etc/fonts
export GO111MODULE=on

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
zstyle :compinstall filename "$ZDOTDIR/.zshrc"

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# End of lines added by compinstall

autoload -Uz promptinit
promptinit

function silence {
  eval "$*" &>/dev/null
}

function prepend-sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"
    CURSOR+=5
  fi
}

function nowrap {
    setterm -linewrap off
    eval "$@"
    setterm -linewrap on
}

function expfactor {
    factor $@ | while read line; do
        echo $line | tr ' ' '\n' | uniq -c | awk --lint '!/:/{print $2"^"$1};/:/{print $2}' | tr '\n' ' ' | xargs
    done
}

zle -N prepend-sudo
bindkey "^[s" prepend-sudo

#bindkey "^[^[[C" forward-word     # Ctrl+right  => forward word
#bindkey "^[0;d" backward-word    # Ctrl+left   => backward word

bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward

# Enforce default grep colos
export GREP_COLOR="01;31"
export GREP_COLORS="mt=$GREP_COLOR"

export LESSHISTSIZE=0
export LESSHISTFILE=/dev/null
export XDG_CACHE_DIR="$HOME/.cache"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/emil/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
export XAUTHORITY="$XDG_CONFIG_HOME/X11/Xauthority"

export TEXMFDIST="/usr/share/texmf-dist"

export PATH="/usr/bin/vendor_perl:$PATH"
export PATH="$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
