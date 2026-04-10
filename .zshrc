include () {
    [[ -f "$1" ]] && source "$1"
}

include ~/.zshrc_work
include ~/.zshrc_local

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

export COLORTERM=truecolor
export EDITOR=ec

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

function f_to_bf() {
    python -c "import numpy as np; print((np.frombuffer(np.float32(${1}).tobytes(), dtype=np.uint32) >> 16)[0])"
}

function bf_to_f() {
    python -c "import numpy as np; print(np.frombuffer((np.uint32(${1}) << 16).tobytes(), dtype=np.float32)[0])"
}

include ~/.fzf.zsh 
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

set_tty() {
    tmux set-environment -g SSH_TTY $(tty)
}

export PATH="$HOME/.local/bin:$PATH"

function sum() {
    awk '{sum+=$1} END {print sum}'
}
