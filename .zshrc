export ZSH="$HOME/.shell/oh-my-zsh"
export ZSH_CONFIG_DIR="$HOME/.shell/zsh"
#export HISTFILE="$ZSH_CONFIG_DIR/"
PATH=$PATH:"$HOME/.shell/scripts:$HOME/.local/bin:"

ZSH_THEME="aussiegeek"

for source_file in $(ls -A $ZSH_CONFIG_DIR); do
  source "$ZSH_CONFIG_DIR/$source_file"
done;

if [ -z "$IS_SSH_HOST" ]; then
  ZSH_TMUX_AUTOSTART=true
  echo true
else
  ZSH_TMUX_AUTOSTART=false
  echo false
fi
plugins=(git git-lfs tmux)

source $ZSH/oh-my-zsh.sh
