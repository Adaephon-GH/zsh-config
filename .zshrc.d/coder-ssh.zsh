# Offer `coder.<workspace>` hostnames when completing ssh/scp/sftp.
#
# `coder config-ssh` only writes a wildcard `Host coder.*` stanza and pins
# UserKnownHostsFile=/dev/null, so no concrete hostname ever lands in
# known_hosts and zsh has nothing to complete. Workspace names come from
# coder's own completion hook instead.
(( $+commands[coder] )) || return

# Matches `coder config-ssh --ssh-host-prefix` (default `coder.`).
: ${CODER_SSH_HOST_PREFIX:=coder.}

_coder_ssh_hosts() {
    local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh-coder-workspaces
    # Same staleness idiom as the .zcompdump check in .zshrc: refresh when
    # the cache is missing, empty, or older than 5 minutes.
    local -a stale=( $cache(N.mm+5) )
    if [[ ! -s $cache ]] || (( $#stale )); then
        local names
        # Hard timeout so an unreachable Coder server can't hang the shell.
        names=$(timeout 2 env COMPLETION_MODE=1 coder ssh '' 2>/dev/null)
        # Only overwrite on success; a failed query keeps the previous list.
        [[ -n $names ]] && print -r -- $names >| $cache
    fi
    [[ -s $cache ]] || return 1

    local -a workspaces=( ${(f)"$(<$cache)"} )
    (( $#workspaces )) || return 1
    # Same matching spec _hosts uses, so partial matching behaves like it
    # does for real hostnames.
    compadd -M 'm:{a-zA-Z}={A-Za-z} r:|.=* r:|=*' "$@" -- \
        ${workspaces/#/$CODER_SSH_HOST_PREFIX}
}

# Wrap the stock _ssh_hosts (shared by ssh, scp and sftp) so coder hosts are
# offered *in addition to* everything it already finds. The guard keeps a
# re-source from wrapping the wrapper and recursing forever.
if (( ! $+functions[_coder_orig_ssh_hosts] )); then
    autoload +X _ssh_hosts 2>/dev/null
    functions[_coder_orig_ssh_hosts]=$functions[_ssh_hosts]
    _ssh_hosts() {
        local ret=1
        _coder_orig_ssh_hosts "$@" && ret=0
        _coder_ssh_hosts "$@" && ret=0
        return ret
    }
fi
