# init completions
autoload -U +X compinit && compinit

# friendly plugins paths
zstyle ':antidote:bundle' use-friendly-names 'yes'

# Lazy-load antidote and generate the static load file only when needed
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
fi
source ${zsh_plugins}.zsh

eval "$(thefuck --alias)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# User configuration
# Setup catppuccin flavour (used in nvim, tmux, etc.)
export CATPPUCCIN_FLAVOUR="macchiato"
export BAT_THEME="Catppuccin-$CATPPUCCIN_FLAVOUR"

# Build bat themes if necessary
bat --list-themes | grep -q "Catppuccin" || bat cache --build

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

# Add rust (cargo) executables
export CARGO_HOME=$HOME/.cargo
export PATH="$CARGO_HOME/bin:$PATH"

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

# replace cd
alias cd="z"
alias zz="z -"
# replace ls
alias ls="exa"
alias ll="exa -alh"
alias tree="exa --tree"
# replace cat
alias cat="bat -pp"

# fuzzy find a folder, then open in neovim
alias nv="fd --type file --exclude .git | fzf-tmux -p --reverse | xargs nvim"

# OpenAI API key for https://github.com/Bryley/neoai.nvim
export OPENAI_API_KEY=$(cat ~/.openai)

# overrides for work
[[ -s "$HOME/.zshrc-extras" ]] && source "$HOME/.zshrc-extras"

# If you do not plan on having Home Manager manage your shell configuration
# then you must source the file in your shell configuration
[[ -s "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]] && source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

# Enable direnv to enable nix-shell when cd into a dir with default.nix file
eval "$(direnv hook zsh)"

