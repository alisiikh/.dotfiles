# Init Antidote zsh plugin manager
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# friendly plugins paths
zstyle ':antidote:bundle' use-friendly-names 'yes'

eval "$(thefuck --alias)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# User configuration
# Setup catppuccin flavour (used in nvim, tmux, etc.)
export CATPPUCCIN_FLAVOUR="macchiato"

# Catppuccin syntax highlighting
source $HOME/.zsh/catppuccin-$CATPPUCCIN_FLAVOUR.zsh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vi'
else
  export EDITOR='nvim'
fi

# ~/.tmux/plugins
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
# ~/.config/tmux/plugins
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Enable pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zconf="nvim ~/.zshrc"
alias aws=awscliv2
alias tf=terraform
alias k=kubectl
alias v=nvim
alias vim=nvim

alias ll="ls -la"
alias nv="fd --type file --exclude .git | fzf-tmux -p --reverse | xargs nvim"

# OpenAI API key for https://github.com/Bryley/neoai.nvim
export OPENAI_API_KEY=$(cat ~/.openai)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# overrides for work
[[ -s "$HOME/.zshrc-extras" ]] && source "$HOME/.zshrc-extras"