export ZSH="$HOME/.oh-my-zsh"
export ZSH_CONFIG_DIR="$HOME/.zsh"
#export HISTFILE="$ZSH_CONFIG_DIR/"
PATH=$PATH:"~/miniscripts:~/.local/bin:"

ZSH_THEME="aussiegeek"
ZSH_TMUX_AUTOSTART=true


plugins=(git git-lfs tmux)
source $ZSH/oh-my-zsh.sh

for source_file in $(ls -A $ZSH_CONFIG_DIR); do
  source "$ZSH_CONFIG_DIR/$source_file"
done;


