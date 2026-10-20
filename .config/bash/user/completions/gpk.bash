# ==============================================================================
# Completion: gpk (Bash)
# Description: Advanced programmable tab-completion for the gpk CLI tool.
# ==============================================================================
_gpk() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Handle value completion for manager flags
    case "$prev" in
        -m|--manager)
            local managers
            managers=$(gpk completions managers 2>/dev/null)
            mapfile -t COMPREPLY < <(compgen -W "$managers" -- "$cur")
            return 0
            ;;
    esac

    # If typing a flag, suggest global options
    if [[ "$cur" == -* ]]; then
        local flags="-h --help -v --version -m --manager"
        mapfile -t COMPREPLY < <(compgen -W "$flags" -- "$cur")
        return 0
    fi

    # Find the actual subcommand (skipping global flags and their arguments)
    local cmd=""
    local i=1
    while [[ $i -lt $COMP_CWORD ]]; do
        local arg="${COMP_WORDS[i]}"
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
        local commands
        commands=$(gpk completions commands 2>/dev/null)
        mapfile -t COMPREPLY < <(compgen -W "$commands" -- "$cur")
        return 0
    fi

    # Complete subcommand-specific arguments
    case "$cmd" in
        remove|upgrade|info|source-of|downgrade|hold)
            local installed
            installed=$(gpk completions installed 2>/dev/null)
            mapfile -t COMPREPLY < <(compgen -W "$installed" -- "$cur")
            ;;
        unhold)
            local held
            held=$(gpk completions held 2>/dev/null)
            mapfile -t COMPREPLY < <(compgen -W "$held" -- "$cur")
            ;;
    esac
}

complete -F _gpk gpk