export ZSH="$HOME/.oh-my-zsh"
export ZSH_CONFIG_DIR="$HOME/.zsh"
PATH=$PATH:"~/miniscripts:/home/kg/.local/bin"

ZSH_THEME="aussiegeek"


plugins=(git)
source $ZSH/oh-my-zsh.sh

for source_file in $(ls -A $ZSH_CONFIG_DIR); do
  source "$ZSH_CONFIG_DIR/$source_file"
done;


