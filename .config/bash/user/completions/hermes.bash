# Hermes Agent bash completion
# Add to ~/.bashrc:
#   eval "$(hermes completion bash)"

_hermes_profiles() {
    local profiles_dir="$HOME/.hermes/profiles"
    local profiles="default"
    if [ -d "$profiles_dir" ]; then
        for f in "$profiles_dir"/*/; do
            [ -d "$f" ] && profiles="$profiles $(basename "$f")"
        done
    fi
    echo "$profiles"
}

_hermes_completion() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Complete profile names after -p / --profile
    if [[ "$prev" == "-p" || "$prev" == "--profile" ]]; then
        COMPREPLY=($(compgen -W "$(_hermes_profiles)" -- "$cur"))
        return
    fi

    if [[ $COMP_CWORD -ge 2 ]]; then
        case "${COMP_WORDS[1]}" in
        acp)
            COMPREPLY=($(compgen -W "-h --help --accept-hooks --version --check --setup --setup-browser --yes -y" -- "$cur"))
            return
            ;;
        approvals)
            COMPREPLY=($(compgen -W "suggest test" -- "$cur"))
            return
            ;;
        auth)
            COMPREPLY=($(compgen -W "add list logout priority refresh remove reset spotify status upgrade" -- "$cur"))
            return
            ;;
        backup)
            COMPREPLY=($(compgen -W "-h --help -o --output -q --quick -l --label -k --keep" -- "$cur"))
            return
            ;;
        browser)
            COMPREPLY=($(compgen -W "close-profile" -- "$cur"))
            return
            ;;
        bundles)
            COMPREPLY=($(compgen -W "create delete list reload show" -- "$cur"))
            return
            ;;
        chat)
            COMPREPLY=($(compgen -W "-h --help -q --query --query-file --oneshot --image -m --model -t --toolsets --reasoning -s --skills --provider -v --verbose -Q --quiet --format --resume -r --no-restore-cwd --in --continue -c --create-if-missing --worktree -w --accept-hooks --checkpoints --max-turns --run-budget --yolo --pass-session-id --ignore-user-config --ignore-rules --safe-mode --source --tui --cli --dev" -- "$cur"))
            return
            ;;
        checkpoints)
            COMPREPLY=($(compgen -W "clear clear-legacy list prune status" -- "$cur"))
            return
            ;;
        claw)
            COMPREPLY=($(compgen -W "cleanup migrate" -- "$cur"))
            return
            ;;
        codex-runtime)
            COMPREPLY=($(compgen -W "migrate" -- "$cur"))
            return
            ;;
        completion)
            COMPREPLY=($(compgen -W "-h --help" -- "$cur"))
            return
            ;;
        computer-use)
            COMPREPLY=($(compgen -W "doctor install permissions screen status" -- "$cur"))
            return
            ;;
        config)
            COMPREPLY=($(compgen -W "check edit env-path get migrate path set show unset" -- "$cur"))
            return
            ;;
        console)
            COMPREPLY=($(compgen -W "-h --help" -- "$cur"))
            return
            ;;
        cron)
            COMPREPLY=($(compgen -W "create doctor edit incidents list notepad pause remove resume run runs status tick" -- "$cur"))
            return
            ;;
        curator)
            COMPREPLY=($(compgen -W "adopt archive backup ledger list-archived list-unmanaged pause pin prune purge restore resume rollback run status unpin usage" -- "$cur"))
            return
            ;;
        dashboard)
            COMPREPLY=($(compgen -W "register" -- "$cur"))
            return
            ;;
        debug)
            COMPREPLY=($(compgen -W "delete share" -- "$cur"))
            return
            ;;
        desktop)
            COMPREPLY=($(compgen -W "-h --help --source --build-only --fake-boot --ignore-existing --hermes-root --cwd --skip-build --local --force-build --setup-tcc-identity --identity" -- "$cur"))
            return
            ;;
        doctor)
            COMPREPLY=($(compgen -W "-h --help --fix --live --ack" -- "$cur"))
            return
            ;;
        dump)
            COMPREPLY=($(compgen -W "-h --help --show-keys" -- "$cur"))
            return
            ;;
        egress)
            COMPREPLY=($(compgen -W "config disable install reload restart setup start status stop" -- "$cur"))
            return
            ;;
        fallback)
            COMPREPLY=($(compgen -W "add clear list remove" -- "$cur"))
            return
            ;;
        gateway)
            COMPREPLY=($(compgen -W "enroll install list migrate migrate-legacy restart run setup start status stop uninstall" -- "$cur"))
            return
            ;;
        hooks)
            COMPREPLY=($(compgen -W "doctor list revoke test" -- "$cur"))
            return
            ;;
        import)
            COMPREPLY=($(compgen -W "-h --help --force -f" -- "$cur"))
            return
            ;;
        import-agent)
            COMPREPLY=($(compgen -W "-h --help --source --dry-run --overwrite --yes -y --sync" -- "$cur"))
            return
            ;;
        insights)
            COMPREPLY=($(compgen -W "-h --help --days --source" -- "$cur"))
            return
            ;;
        journey)
            COMPREPLY=($(compgen -W "delete edit list" -- "$cur"))
            return
            ;;
        kanban)
            COMPREPLY=($(compgen -W "archive assign assignees attach attach-rm attachments block boards claim comment complete context create daemon decompose diagnostics dispatch edit gc heartbeat init link list log notify-list notify-subscribe notify-unsubscribe promote reassign reclaim reopen-review repair request-changes request-review runs schedule set-model show specify stats swarm tail unblock unlink watch" -- "$cur"))
            return
            ;;
        logout)
            COMPREPLY=($(compgen -W "-h --help --provider" -- "$cur"))
            return
            ;;
        logs)
            COMPREPLY=($(compgen -W "-h --help -n --lines -f --follow --level --session --since --component" -- "$cur"))
            return
            ;;
        lsp)
            COMPREPLY=($(compgen -W "install install-all list restart status which" -- "$cur"))
            return
            ;;
        mcp)
            COMPREPLY=($(compgen -W "add catalog configure install list login picker reauth remove serve test" -- "$cur"))
            return
            ;;
        memory)
            COMPREPLY=($(compgen -W "off reset setup status" -- "$cur"))
            return
            ;;
        migrate)
            COMPREPLY=($(compgen -W "relay xai" -- "$cur"))
            return
            ;;
        moa)
            COMPREPLY=($(compgen -W "configure delete list" -- "$cur"))
            return
            ;;
        model)
            COMPREPLY=($(compgen -W "-h --help --refresh --portal-url --inference-url --client-id --scope --no-browser --timeout --ca-bundle --insecure" -- "$cur"))
            return
            ;;
        monitoring)
            COMPREPLY=($(compgen -W "status" -- "$cur"))
            return
            ;;
        pairing)
            COMPREPLY=($(compgen -W "approve clear-pending list revoke" -- "$cur"))
            return
            ;;
        pause)
            COMPREPLY=($(compgen -W "-h --help --reason" -- "$cur"))
            return
            ;;
        peer)
            COMPREPLY=($(compgen -W "add dm list remove run status stop" -- "$cur"))
            return
            ;;
        pets)
            COMPREPLY=($(compgen -W "doctor install list off remove scale select show" -- "$cur"))
            return
            ;;
        plugins)
            COMPREPLY=($(compgen -W "browse capabilities compat disable doctor enable install list pack remove search show update validate" -- "$cur"))
            return
            ;;
        portal)
            COMPREPLY=($(compgen -W "info login open tools" -- "$cur"))
            return
            ;;
        profile)
            case "$prev" in
                profile)
                    COMPREPLY=($(compgen -W "alias create delete describe export import info install list migrate-identity purge-identity rename show update use" -- "$cur"))
                    return
                    ;;
                use|delete|show|alias|rename|export)
                    COMPREPLY=($(compgen -W "$(_hermes_profiles)" -- "$cur"))
                    return
                    ;;
            esac
            ;;
        project)
            COMPREPLY=($(compgen -W "add-folder archive bind-board create list remove-folder rename restore set-primary show use" -- "$cur"))
            return
            ;;
        prompt-size)
            COMPREPLY=($(compgen -W "-h --help --platform --json" -- "$cur"))
            return
            ;;
        proxy)
            COMPREPLY=($(compgen -W "providers start status" -- "$cur"))
            return
            ;;
        resume)
            COMPREPLY=($(compgen -W "-h --help" -- "$cur"))
            return
            ;;
        secrets)
            COMPREPLY=($(compgen -W "bitwarden onepassword" -- "$cur"))
            return
            ;;
        security)
            COMPREPLY=($(compgen -W "audit" -- "$cur"))
            return
            ;;
        send)
            COMPREPLY=($(compgen -W "-h --help -t --to -f --file -s --subject --mention -l --list -q --quiet --json" -- "$cur"))
            return
            ;;
        serve)
            COMPREPLY=($(compgen -W "-h --help --port --host --insecure --skip-build --isolated --open-profile --stop --status --no-open --ssh-session-token-file --ssh-owner-nonce" -- "$cur"))
            return
            ;;
        sessions)
            COMPREPLY=($(compgen -W "archive browse clean-markers delete export import list optimize optimize-storage pin pinned prune recover rename repair repair-profiles repair-routing retitle-skills set-journal-mode stats unpin" -- "$cur"))
            return
            ;;
        setup)
            COMPREPLY=($(compgen -W "-h --help --non-interactive --reset --reconfigure --quick --portal" -- "$cur"))
            return
            ;;
        skills)
            COMPREPLY=($(compgen -W "audit browse check config diff inspect install list list-modified opt-in opt-out publish repair-official reset search snapshot tap trust uninstall untrust update" -- "$cur"))
            return
            ;;
        skin)
            COMPREPLY=($(compgen -W "list set use" -- "$cur"))
            return
            ;;
        slack)
            COMPREPLY=($(compgen -W "manifest" -- "$cur"))
            return
            ;;
        status)
            COMPREPLY=($(compgen -W "-h --help --all --deep" -- "$cur"))
            return
            ;;
        sync)
            COMPREPLY=($(compgen -W "device disable enable now propose pull push status" -- "$cur"))
            return
            ;;
        tools)
            COMPREPLY=($(compgen -W "disable enable list post-setup" -- "$cur"))
            return
            ;;
        uninstall)
            COMPREPLY=($(compgen -W "-h --help --full --gui --gui-summary --yes -y --dry-run" -- "$cur"))
            return
            ;;
        update)
            COMPREPLY=($(compgen -W "-h --help --gateway --check --plan --list-venv-holders --no-backup --backup --yes -y --keep-stash --branch --switch-branch --force --force-venv --no-gateway-restart --post-swap" -- "$cur"))
            return
            ;;
        usage)
            COMPREPLY=($(compgen -W "-h --help --provider --json" -- "$cur"))
            return
            ;;
        vault)
            COMPREPLY=($(compgen -W "add list rm sources" -- "$cur"))
            return
            ;;
        verify)
            COMPREPLY=($(compgen -W "-h --help --detect-only --save --skip-start --phase --port --timeout --ready-timeout --json" -- "$cur"))
            return
            ;;
        webhook)
            COMPREPLY=($(compgen -W "list remove subscribe test" -- "$cur"))
            return
            ;;
        whatsapp)
            COMPREPLY=($(compgen -W "-h --help" -- "$cur"))
            return
            ;;
        whatsapp-cloud)
            COMPREPLY=($(compgen -W "-h --help" -- "$cur"))
            return
            ;;
        worktree)
            COMPREPLY=($(compgen -W "list prune" -- "$cur"))
            return
            ;;
        esac
    fi

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "acp approvals auth backup browser bundles chat checkpoints claw codex-runtime completion computer-use config console cron curator dashboard debug desktop doctor dump egress fallback gateway hooks import import-agent insights journey kanban logout logs lsp mcp memory migrate moa model monitoring pairing pause peer pets plugins portal profile project prompt-size proxy resume secrets security send serve sessions setup skills skin slack status sync tools uninstall update usage vault verify webhook whatsapp whatsapp-cloud worktree" -- "$cur"))
    fi
}

complete -F _hermes_completion hermes

