export ZSH="$HOME/.shell/oh-my-zsh"
export ZSH_CONFIG_DIR="$HOME/.shell/zsh/"
# export ZSH_CONFIG_MANUAL_DIR="$HOME/.shell/zsh-manual/"
#export HISTFILE="$ZSH_CONFIG_DIR/"
PATH=$PATH:"$HOME/.shell/scripts:$HOME/.local/bin:"

ZSH_THEME="aussiegeek"

# source "${ZSH_CONFIG_MANUAL_DIR}tmux"

for source_file in $(ls -A $ZSH_CONFIG_DIR); do
  source "${ZSH_CONFIG_DIR}${source_file}"
done;

ZSH_TMUX_AUTOSTART=false
if [[ -z "$IS_SSH_HOST" ]] && [[ -z "$TMUX" ]]; then
  enter-tmux-session $FOREGROUND_SESSION_NAME
fi
plugins=(git git-lfs tmux)

source $ZSH/oh-my-zsh.sh
