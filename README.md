# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Works on Ubuntu, RHEL/CentOS/Rocky, and macOS (future).

## Quick start

```bash
git clone git@github.com:YOU/dotfiles.git ~/.dotfiles
bash ~/.dotfiles/bootstrap.sh [--stow-only | --pkgs-only]
```

> --stow-only    skip package install, only run stow
> --pkgs-only    skip stow, only install packages

That's it. The script detects your OS, installs all tools, and symlinks configs.


## Structure

```
dotfiles/
├── stow/                   # each subdir = one stow package
│   ├── fzf/              # shared: aliases, exports, functions
│   │   └──.config/
│   │       └── fzf.bash
│   ├── bash/               # .bashrc, .bash_profile
│   ├── git/                # .gitconfig (with delta)
│   ├── tmux/               # .tmux.conf
│   ├── starship/.config    # .config/starship.toml
│   ├── vim/                # .vimrc (optional)
│   ├── nvim/               # .config/nvim/ (optional)
│   └── yazi/               # .config/yazi/ (optional)
│
├── install/
│   ├── detect-os.sh        # sets $OS, $DISTRO, $PKG_MGR, $ARCH
│   ├── linux-ubuntu.sh
│   ├── linux-rhel.sh
│   └── darwin.sh           # macOS (Homebrew)
│
└── bootstrap.sh            # entry point
```

## Machine-local config

`~/.config/shell/local` is created by bootstrap but **not tracked in git**.
Put machine-specific things here:

```bash
# ~/.config/shell/local
# Machine-specific — NOT tracked in git
# work laptop

# ── identity ──────────────────────────────────────────────────────────────────
export GIT_AUTHOR_EMAIL="you@company.com"
export GIT_COMMITTER_EMAIL="you@company.com"

# ── corporate proxy ───────────────────────────────────────────────────────────
export HTTP_PROXY="http://proxy.corp.internal:3128"
export HTTPS_PROXY="http://proxy.corp.internal:3128"
export NO_PROXY="localhost,127.0.0.1,.corp.internal"

# ── internal registries ───────────────────────────────────────────────────────
export NPM_REGISTRY="https://artifactory.corp.internal/npm/"
export ARTIFACTORY_TOKEN="eyJhbGciOiJSUzI1NiJ9..."   # never commit this

# ── machine-specific paths ────────────────────────────────────────────────────
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"   # only on this laptop
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"

# ── work k8s clusters ─────────────────────────────────────────────────────────
export KUBECONFIG="$HOME/.kube/work-cluster.yaml:$HOME/.kube/personal.yaml"

# ── ssh agent (differs per machine) ──────────────────────────────────────────
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# ── local overrides ───────────────────────────────────────────────────────────
alias vpn="sudo openconnect vpn.corp.internal --user=you"
```

And the corresponding hook in your `.bashrc` that loads it:

```bash
# near the bottom of .bashrc, after all shared config is sourced
[ -f ~/.config/shell/local ] && source ~/.config/shell/local
```

The `[ -f ... ]` guard means it's a no-op on machines where the file doesn't exist yet — so your shared dotfiles never break on a fresh clone.

## Tools installed

| Tool | Source | Notes |
|------|--------|-------|
| bat | apt/dnf/brew | `batcat` on Ubuntu — symlinked to `bat` |
| btop | GitHub | latest release |
| eza | Official deb / GitHub / brew | latest |
| fastfetch | GitHub | latest release |
| fd | apt/dnf/brew | `fdfind` on Ubuntu — symlinked to `fd` |
| fzf | GitHub (git clone) | always latest |
| fzf-git | GitHub (curl) | latest |
| git-delta | GitHub | latest release |
| jq | apt/dnf/brew | |
| lazygit | GitHub | latest release |
| ncdu | apt/dnf/brew | |
| ripgrep | apt/dnf/brew | |
| starship | Official script | always latest |
| stow | apt/dnf/brew | |
| tmux | apt/dnf/brew | |
| yazi | GitHub | latest release |
| yq | GitHub | latest release |
| zoxide | Official script | always latest |

## Adding a new machine / distro

1. Add `install/linux-<distro>.sh`
2. Add a case to `install/detect-os.sh`
3. Add a case to `bootstrap.sh`

## Updating tools

```bash
bash ~/.dotfiles/install/packages.sh   # re-runs full install (idempotent)
```
