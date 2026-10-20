#compdef gpk
# ==============================================================================
# Completion: gpk (Zsh)
# Description: Advanced programmable tab-completion for the gpk CLI tool.
# ==============================================================================
_gpk() {
    local cur="${words[CURRENT]}"
    local prev="${words[CURRENT-1]}"

    # Handle value completion for manager flags
    if [[ "$prev" == "-m" || "$prev" == "--manager" ]]; then
        local -a managers
        managers=(${(f)"$(gpk completions managers 2>/dev/null)"})
        compadd -a managers
        return 0
    fi

    # If typing a flag, suggest global options
    if [[ "$cur" == -* ]]; then
        local -a flags
        flags=('-h' '--help' '-v' '--version' '-m' '--manager')
        compadd -a flags
        return 0
    fi

    # Find the actual subcommand (skipping global flags and their arguments)
    local cmd=""
    local i=2
    while (( i < CURRENT )); do
        local arg="${words[i]}"
        if [[ "$arg" == "-m" || "$arg" == "--manager" ]]; then
            # Skip both the flag and its following value argument
            ((i+=2))
            continue
        elif [[ "$arg" == -* ]]; then
            # Skip any other flags
            ((i++))
            continue
        else
            # Found the subcommand
            cmd="$arg"
            break
        fi
        ((i++))
    done

    # If no subcommand is typed yet, complete available commands
    if [[ -z "$cmd" ]]; then
        local -a commands
        commands=(${(f)"$(gpk completions commands 2>/dev/null)"})
        compadd -a commands
        return 0
    fi

    # Complete subcommand-specific arguments
    case "$cmd" in
        remove|upgrade|info|source-of|downgrade|hold)
            local -a installed
            installed=(${(f)"$(gpk completions installed 2>/dev/null)"})
            compadd -a installed
            ;;
        unhold)
            local -a held
            held=(${(f)"$(gpk completions held 2>/dev/null)"})
            compadd -a held
            ;;
    esac
}

_gpk "$@"