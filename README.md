# zsh configuration

A long-lived personal zsh setup: a multi-line prompt with VCS/Python/exit-status
info, an emacs keymap with a vi command mode, application-keypad handling, and
fast-syntax-highlighting.

## Layout

| File / dir | Purpose |
|---|---|
| `.zshenv` | Environment for *all* zsh (login, interactive, scripts): `EDITOR`, `PAGER`, `MINICOM`. |
| `.zprofile` | Login shell: pyenv `--path` setup, auto-`startx` on VT1. |
| `.zshrc` | Interactive setup: options, completion (`compinit`), prompt, VCS info, key-widget hooks. |
| `.zshrc.d/*.zsh` | Sourced at the end of `.zshrc`, in filename order (`99-*` first, `zzz-*` last). |
| `.zshrc.local.d/*.zsh` | Optional machine-local drop-ins (sourced if present). |

### Submodules

```sh
git submodule update --init
```

* `fast-syntax-highlighting` — [zdharma-continuum/fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
  (the maintained fork; the original `zdharma` repo was removed from GitHub in 2021).
  If it is not checked out, the shell falls back to zsh's built-in `zle_highlight`.
* `timewarrior_zsh_completion` — completion for Timewarrior. Its directory is
  discovered and added to `$fpath` automatically *before* `compinit` runs — see
  [Completion dump and the distribution's `compinit`](#completion-dump-and-the-distributions-compinit).

## Notes

### Completion dump and the distribution's `compinit`

`.zshenv` sets `skip_global_compinit=1`. On Ubuntu, `/etc/zsh/zshrc` — sourced
*before* `~/.zshrc` — ends with an unconditional `compinit`, which runs while
`$fpath` still lacks the submodule completion directories that `.zshrc` adds.

This matters more than a wasted `compinit` call, because **`compinit` decides
whether an existing `~/.zcompdump` can be reused by comparing only the file
*count* recorded in its header against the files currently in `$fpath`.** With
both `compinit` calls sharing one dump file they fight over it:

1. `/etc/zsh/zshrc` writes a dump without the submodule completions.
2. `.zshrc` finds that dump fresh, runs `compinit -C`, and loads it verbatim —
   `_timew` is never registered.
3. Once the dump passes the 24h mark, `.zshrc`'s full `compinit` notices the
   count mismatch, rescans, and writes a correct dump — completion works.
4. The next shell started runs the global `compinit`, sees *its* count mismatch,
   rescans without the submodule directories and resets the dump. Broken again.

Skipping the global call leaves `.zshrc` as the single writer, so the dump
always matches the `$fpath` it was built from.

Two consequences of the count-only reuse test are worth knowing:

* Adding or removing a completion file changes the count and is picked up
  automatically. **Editing one in place is not** — within the 24h window
  `compinit -C` loads the old dump regardless. Run `rm ~/.zcompdump` and start a
  new shell to force a rebuild.
* When the count is unchanged, a full `compinit` sources the dump and returns
  *without rewriting it*, leaving the mtime untouched. `.zshrc` therefore
  `touch`es the dump itself after the daily run; otherwise it would stay stale
  forever and every shell would pay for a full `compaudit`.

### Redrawing the prompt on window resize

`.zshrc` installs a `TRAPWINCH` handler that runs `zle reset-prompt` so the
**prompt currently being edited** reflows when the terminal is resized — this
matters here because the top status rule and the right-aligned middle segment
are computed from `$COLUMNS`.

**Prompts printed earlier cannot be redrawn.** This is a terminal limitation,
not a shell one: the terminal keeps a grid of already-rendered cells in its
scrollback, not the zsh source that produced them, so there is nothing for zsh
to re-expand. No terminal (kitty included) exposes an API to reflow historical
scrollback. Only the active line editor is under the shell's control.

### Distinguishing Enter / Shift+Enter / Ctrl+Enter in kitty

By default a terminal sends the same byte (`\r`, `0x0d`) for Enter regardless of
modifiers, so the shell cannot tell `Shift+Enter` or `Ctrl+Enter` apart. kitty
can, via the **kitty keyboard protocol** (a.k.a. the CSI-u progressive
enhancement). Two ways to use it:

**A. Enable the protocol from zsh (shell-side).** Push the "disambiguate escape
codes" flag when the line editor starts and pop it when it ends, then bind the
CSI-u sequences. This is *not enabled by default here* because it interacts with
existing bindings (see caveats). A ready-to-adapt, kitty-guarded snippet — drop
it in e.g. `.zshrc.local.d/kitty-keys.zsh`:

```zsh
if [[ $TERM == xterm-kitty ]]; then
    _kitty_kbd_on()  { print -n '\e[>1u' }   # push: disambiguate escape codes
    _kitty_kbd_off() { print -n '\e[<u'  }    # pop back to the previous mode
    zle -N _kitty_kbd_on
    zle -N _kitty_kbd_off
    add-zle-hook-widget line-init   _kitty_kbd_on
    add-zle-hook-widget line-finish _kitty_kbd_off

    # With the protocol on, modified Enter arrives as CSI 13 ; <mod> u.
    # Modifier number = 1 + shift(1) + alt(2) + ctrl(4); so Shift=2, Ctrl=5.
    bindkey '\e[13;2u' self-insert-unmeta   # Shift+Enter -> literal newline
    bindkey '\e[13;5u' self-insert-unmeta   # Ctrl+Enter  -> literal newline
    # (use `accept-line` instead if you want that key to run the command)
fi
```

Plain Enter is unaffected (still `\r`); only the modified variants become
`\e[13;2u` / `\e[13;5u`.

> **Caveats — why it is off by default.** With the disambiguate flag enabled,
> keys that lacked a unique legacy encoding change how they report. In
> particular **Escape alone becomes `\e[27u`**, which would break
> `bindkey "^[" vi-cmd-mode` (`.zshrc.d/bindkey.zsh`) and various `Alt-`/`Ctrl-`
> bindings until they are re-bound to their CSI-u forms. That is why the snippet
> guards on `$TERM == xterm-kitty` and toggles the mode only *inside* the line
> editor. Enable it only after adding matching bindings (at minimum
> `bindkey '\e[27u' vi-cmd-mode`) and testing.

**B. Map it in `kitty.conf` (terminal-side).** Simpler and needs no protocol
changes in the shell; kitty translates the keypress to bytes you then bind:

```conf
# ~/.config/kitty/kitty.conf
map shift+enter send_text all \x1b[13;2u
map ctrl+enter  send_text all \x1b[13;5u
```

```zsh
# in zsh
bindkey '\e[13;2u' self-insert-unmeta
bindkey '\e[13;5u' self-insert-unmeta
```
