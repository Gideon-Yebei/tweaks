# ==============================================================================
# Function: git-set-gh-user (Zsh)
# Description: Select an authenticated GitHub account from a numbered list, 
#              ensures required scopes, and configures local Git user.name/email.
# ==============================================================================
git-set-gh-user() {
    # Colors
    local c_reset="\033[0m"
    local c_green="\033[1;32m"
    local c_yellow="\033[1;33m"
    local c_red="\033[1;31m"
    local c_cyan="\033[1;36m"
    local c_dim="\033[2m"

    # Ensure GitHub CLI is installed
    if ! (( $+commands[gh] )); then
        echo -e "${c_red}[Error]${c_reset} 'gh' CLI tool is not installed or not found in PATH." >&2
        return 1
    fi

    # Check authentication status
    local auth_check
    auth_check=$(gh auth status 2>&1)
    if [[ $? -ne 0 ]]; then
        if [[ "$auth_check" == *"not logged in"* || "$auth_check" == *"No accounts"* ]]; then
            echo -e "${c_yellow}ℹ Not logged in. Starting GitHub authentication...${c_reset}"
            gh auth login --scopes user,user:email
            if [[ $? -ne 0 ]]; then
                echo -e "${c_red}[Error]${c_reset} Authentication failed." >&2
                return 1
            fi
        fi
    fi

    # Extract logged-in accounts
    local accounts=()
    for line in ${(f)"$(gh auth status 2>&1)"}; do
        if [[ "$line" == *"Logged in to"* ]]; then
            local user
            user=$(echo "$line" | sed -E 's/.*account ([^[:space:]]+).*/\1/')
            if [[ -n "$user" && ${accounts[(Ie)$user]} -eq 0 ]]; then
                accounts+=("$user")
            fi
        fi
    done

    local active_user
    active_user=$(gh api user --jq '.login' 2>/dev/null)

    if [[ ${#accounts[@]} -eq 0 ]]; then
        if [[ -n "$active_user" ]]; then
            accounts=("$active_user")
        else
            echo -e "${c_red}[Error]${c_reset} No authenticated GitHub accounts found. Please run 'gh auth login'." >&2
            return 1
        fi
    fi

    # Reorder accounts so active user is always first (#1 default choice)
    if (( ${accounts[(Ie)$active_user]} )); then
        accounts=("$active_user" ${accounts:#$active_user})
    fi

    # Display numbered list for selection
    echo -e "${c_cyan}Select GitHub account for local git config:${c_reset}"
    integer i=1
    for acc in "${accounts[@]}"; do
        if [[ "$acc" == "$active_user" ]]; then
            echo -e "  ${c_green}[$i]${c_reset} $acc ${c_dim}(active / default)${c_reset}"
        else
            echo -e "  ${c_cyan}[$i]${c_reset} $acc"
        fi
        ((i++))
    done

    local selection
    echo -n "${c_yellow}⟠ Choose account number [default: 1 ($active_user)]: ${c_reset}"
    read selection
    selection="${selection:-1}"

    # Validate input
    if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
        echo -e "${c_red}[Error]${c_reset} Invalid selection. Please enter a number." >&2
        return 1
    fi

    if (( selection < 1 || selection > ${#accounts[@]} )); then
        echo -e "${c_red}[Error]${c_reset} Selection out of range." >&2
        return 1
    fi

    local target_user="${accounts[$selection]}" # Zsh is 1-indexed

    # Switch account if target differs from current active user
    if [[ "$target_user" != "$active_user" ]]; then
        echo -e "${c_dim}Switching active 'gh' account to $target_user...${c_reset}"
        gh auth switch --user "$target_user"
        if [[ $? -ne 0 ]]; then
            echo -e "${c_red}[Error]${c_reset} Failed to switch to account $target_user." >&2
            return 1
        fi
    fi

    # Apply username to local git config
    git config user.name "$target_user"

    # Fetch GitHub email (prioritize noreply, fallback to primary)
    local gh_email
    gh_email=$(gh api user/emails --jq '.[] | select(.email | contains("noreply")) | .email' 2>/dev/null | head -n 1)
    if [[ -z "$gh_email" ]]; then
        gh_email=$(gh api user/emails --jq '.[] | select(.primary == true) | .email' 2>/dev/null | head -n 1)
    fi

    if [[ -z "$gh_email" || "$gh_email" == "null" ]]; then
        echo -e "${c_yellow}ℹ Missing 'user:email' scope. Requesting re-authentication with required scopes...${c_reset}"
        gh auth refresh --scopes user,user:email
        gh_email=$(gh api user/emails --jq '.[] | select(.email | contains("noreply")) | .email' 2>/dev/null | head -n 1)
        if [[ -z "$gh_email" ]]; then
            gh_email=$(gh api user/emails --jq '.[] | select(.primary == true) | .email' 2>/dev/null | head -n 1)
        fi
    fi

    if [[ -n "$gh_email" && "$gh_email" != "null" ]]; then
        git config user.email "$gh_email"
    else
        echo -e "${c_red}[Error]${c_reset} Could not retrieve a valid email from the GitHub API for $target_user." >&2
        return 1
    fi

    # Success feedback
    local final_name final_email
    final_name=$(git config user.name)
    final_email=$(git config user.email)

    echo -e "${c_green}✓ Local repository profile successfully updated:${c_reset}"
    echo -e "  ${c_dim}Name:${c_reset}  $final_name"
    echo -e "  ${c_dim}Email:${c_reset} $final_email"
}