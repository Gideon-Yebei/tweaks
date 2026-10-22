# Define the user config directory
BASH_USER_DIR="$HOME/.config/bash/user"

# Source Custom Tab-Completions
if [[ -d "$BASH_USER_DIR/completions" ]]; then
    for file in "$BASH_USER_DIR/completions"/*.bash; do
        [[ -f "$file" ]] && source "$file"
    done
fi

# Source Custom Functions
if [[ -d "$BASH_USER_DIR/functions" ]]; then
    for file in "$BASH_USER_DIR/functions"/*.bash; do
        [[ -f "$file" ]] && source "$file"
    done
fi
