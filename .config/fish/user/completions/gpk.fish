# ==============================================================================
# Completion: gpk (Fish)
# Description: Advanced programmable tab-completion for the gpk CLI tool.
# ==============================================================================

# Disable default file completions unless explicitly needed
complete -c gpk -f

# Global Flags and Options
complete -c gpk -s h -l help -d "Display help information"
complete -c gpk -s v -l version -d "Display version information"
complete -c gpk -s m -l manager -d "Specify package manager" -xa "(gpk completions managers 2>/dev/null)"

# Dynamic Subcommands (only complete if no subcommand has been typed yet)
# We safely fetch commands from the CLI dynamically
function __gpk_needs_command
    set -l cmd (commandline -opc)
    # Check if a subcommand is already present (ignoring global flags/arguments)
    for i in (seq (count $cmd))
        switch $cmd[$i]
            case -m --manager
                # Skip the manager flag value argument
                set i (math $i + 1)
            case -h --help -v --version
                # Skip other flags
                continue
            case '*'
                if test $i -gt 1
                    return 1 # Subcommand already exists
                end
        end
    end
    return 0
end

complete -c gpk -n "__gpk_needs_command" -xa "(gpk completions commands 2>/dev/null)"

# Subcommand-Specific Package Arguments (Installed Packages)
complete -c gpk -n "__fish_seen_subcommand_from remove upgrade info source-of downgrade hold" -xa "(gpk completions installed 2>/dev/null)"

# Subcommand-Specific Package Arguments (Held Packages)
complete -c gpk -n "__fish_seen_subcommand_from unhold" -xa "(gpk completions held 2>/dev/null)"