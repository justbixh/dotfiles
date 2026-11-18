# git config setup - multiple git identities across laptop

## In `~/dotfiles/git/.config/git/config`

```ini
[includeIf "gitdir:~/pcc-kubernetes-manifests/"]
    path = ~/.gitconfig.work

[includeIf "gitdir:~/snd-core/"]
    path = ~/.gitconfig.work
```

Or, if work repos share one parent, use a single broader block instead:
```ini
[includeIf "gitdir:~/tayana/"]
    path = ~/.gitconfig.work
```


## create local identity files

```bash
cat > ~/.gitconfig.local <<'EOF'
[user]
    name = Bishnu Work Laptop 
    email = helloatbish@gmail.com
EOF

cat > ~/.gitconfig.work <<'EOF'
[user]
    name = Bishnu
    email = bishnu.p@tayana.in
EOF
```


## Files

`.local` and `.work` live in `$HOME`, as machine-specific, gitignored.

| File | Stowed? | Purpose |
|---|---|---|
| `~/dotfiles/git/.config/git/config` | Yes | Shared config + `include`/`includeIf` rules |
| `~/.gitconfig.local` | No | Default identity, per-machine |
| `~/.gitconfig.work` | No | Work identity, per-machine |


## Dependencies

The shared config assumes these are installed (install steps in `macos/Brewfile` or `more/tool-installation-guide.md`).

| Setting | Needs |
|---|---|
| `core.pager`, `interactive.diffFilter`, `[delta]` | `delta` on `PATH`, otherwise `git log`, `git diff` and `git add -p` fail |
| `core.editor` | `nvim` |
| `merge.conflictstyle = zdiff3` | git 2.35+ |
| `push.autoSetupRemote` | git 2.37+ |
| `credential.helper = store` | none, but tokens are saved in plain text in `~/.git-credentials` |


## Verify

```
```bash
cd ~/pcc-kubernetes-manifests && git config user.email   # bishnu.p@tayana.in
cd ~/dotfiles && git config user.email                   # helloatbish@gmail.com
```
```
