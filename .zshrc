# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Bash variables are described here: https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# See `man zshoptions`.
setopt histappend
setopt extendedhistory
setopt incappendhistory

autoload -U select-word-style
select-word-style bash

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export PATH=$PATH:/usr/lib/llvm-10/bin
export PATH=$PATH:~/bin

TERM=xterm-24bits
export EDITOR=emacs

function swap() {
    current_path=$(pwd)

    if [[ "$current_path" == *"github"* ]];
    then
        cd_to="${current_path/github/build}"
    else
        cd_to="${current_path/build/github}"
    fi

    cd ${cd_to}
}

. /usr/share/doc/fzf/examples/key-bindings.zsh
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
