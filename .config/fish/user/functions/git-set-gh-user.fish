# ==============================================================================
# Function: git-set-gh-user
# Description: Select an authenticated GitHub account from a numbered list using 
#              native Fish colors, ensures required scopes, and configures local Git.
# Usage: git-set-gh-user
# ==============================================================================
function git-set-gh-user --description "Configure local git profile from a numbered GitHub CLI account list"
    # Ensure the GitHub CLI is installed
    if not type -q gh
        set_color -o red
        echo -n "[Error] "
        set_color normal
        echo "'gh' CLI tool is not installed or not found in PATH." >&2
        return 1
    end

    # Check current authentication and ensure basic login
    set -l auth_check (gh auth status 2>&1)
    if test $status -ne 0
        if echo "$auth_check" | grep -q -E "not logged in|No accounts"
            set_color yellow
            echo "ℹ Not logged in. Starting GitHub authentication..."
            set_color normal
            gh auth login --scopes user,user:email
            if test $status -ne 0
                set_color -o red
                echo -n "[Error] "
                set_color normal
                echo "Authentication failed." >&2
                return 1
            end
        end
    end

    # Safely extract all logged-in accounts line-by-line
    set -l accounts
    for line in (gh auth status 2>&1)
        if string match -q "*Logged in to*" $line
            set -l user (echo $line | sed -E 's/.*account ([^[:space:]]+).*/\1/')
            if test -n "$user"
                if not contains -- "$user" $accounts
                    set -a accounts $user
                end
            end
        end
    end

    # Fallback if parsing missed anything
    if test (count $accounts) -eq 0
        set -l active_user (gh api user --jq '.login' 2>/dev/null)
        if test -n "$active_user"
            set accounts $active_user
        else
            set_color -o red
            echo -n "[Error] "
            set_color normal
            echo "No authenticated GitHub accounts found. Please run 'gh auth login'." >&2
            return 1
        end
    end

    # Get current active user
    set -l active_user (gh api user --jq '.login' 2>/dev/null)

    # Reorder accounts so active user is always first (#1 default choice)
    if contains -- "$active_user" $accounts
        set accounts $active_user (string match -v -- "$active_user" $accounts)
    end

    # Display numbered list for selection
    set_color cyan
    echo "Select GitHub account for local git config:"
    set_color normal
    for i in (seq (count $accounts))
        set -l acc $accounts[$i]
        if test "$acc" = "$active_user"
            set_color -o green
            printf "  [%d]" "$i"
            set_color normal
            printf " %s " "$acc"
            set_color brblack
            printf "(active / default)\n"
            set_color normal
        else
            set_color cyan
            printf "  [%d]" "$i"
            set_color normal
            printf " %s\n" "$acc"
        end
    end

    set_color yellow
    printf "⟠ Choose account number [default: 1 (%s)]: " "$active_user"
    set_color normal
    read -l selection

    # Default to 1 if empty
    if test -z "$selection"
        set selection 1
    end

    # Validate input is a number within range
    if not string match -qr '^[0-9]+$' -- "$selection"
        set_color -o red
        echo -n "[Error] "
        set_color normal
        echo "Invalid selection. Please enter a number." >&2
        return 1
    end

    if test "$selection" -lt 1 -o "$selection" -gt (count $accounts)
        set_color -o red
        echo -n "[Error] "
        set_color normal
        echo "Selection out of range." >&2
        return 1
    end

    set -l target_user $accounts[$selection]

    # Switch account if target differs from current active user
    if test "$target_user" != "$active_user"
        set_color brblack
        echo "Switching active 'gh' account to $target_user..."
        set_color normal
        gh auth switch --user "$target_user"
        if test $status -ne 0
            set_color -o red
            echo -n "[Error] "
            set_color normal
            echo "Failed to switch to account $target_user." >&2
            return 1
        end
    end

    # Apply username to local git config
    git config user.name "$target_user"

    # Fetch GitHub email (prioritize noreply privacy address, fallback to primary)
    set -l gh_email (gh api user/emails --jq '.[] | select(.email | contains("noreply")) | .email' 2>/dev/null | head -n 1)
    if test -z "$gh_email"
        set gh_email (gh api user/emails --jq '.[] | select(.primary == true) | .email' 2>/dev/null | head -n 1)
    end

    # If email retrieval failed due to missing scope, handle it by refreshing scopes
    if test -z "$gh_email"; or test "$gh_email" = "null"
        set_color yellow
        echo "ℹ Missing 'user:email' scope. Requesting re-authentication with required scopes..."
        set_color normal
        gh auth refresh --scopes user,user:email
        
        # Retry fetching email
        set gh_email (gh api user/emails --jq '.[] | select(.email | contains("noreply")) | .email' 2>/dev/null | head -n 1)
        if test -z "$gh_email"
            set gh_email (gh api user/emails --jq '.[] | select(.primary == true) | .email' 2>/dev/null | head -n 1)
        end
    end

    # Validate email
    if test -n "$gh_email"; and test "$gh_email" != "null"
        git config user.email "$gh_email"
    else
        set_color -o red
        echo -n "[Error] "
        set_color normal
        echo "Could not retrieve a valid email from the GitHub API for $target_user." >&2
        return 1
    end

    # Success feedback
    set -l final_name (git config user.name)
    set -l final_email (git config user.email)

    set_color -o green
    echo "✓ Local repository profile successfully updated:"
    set_color normal
    set_color brblack
    printf "  Name:  "
    set_color normal
    echo "$final_name"
    set_color brblack
    printf "  Email: "
    set_color normal
    echo "$final_email"
end