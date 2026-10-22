# Define the user config directory
ZSH_USER_DIR="$HOME/.config/zsh/user"

# Load Custom Tab-Completions
if [[ -d "$ZSH_USER_DIR/completions" ]]; then
    fpath=("$ZSH_USER_DIR/completions" $fpath)
    # Note: Ensure compinit is called AFTER modifying fpath
fi

# Load Custom Functions (Autoloaded on demand)
if [[ -d "$ZSH_USER_DIR/functions" ]]; then
    fpath=("$ZSH_USER_DIR/functions" $fpath)
    # Mark all files in this directory for autoloading
    for func in "$ZSH_USER_DIR/functions"/*(N-.); do
        autoload -Uz "${func:t}"
    done
fi
