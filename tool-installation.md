# INSTALL.md — Package Installation Reference

> Run `check.sh` first to see what's missing, then use the commands below.


## PATH — do this first

```bash
mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"   # also add this to ~/.zshrc
```

## APT packages (Ubuntu / Debian)

```bash
sudo apt-get update -y

sudo apt-get install -y \
    git \
    curl \
    stow \
    tmux \
    btop \
    bat \
    fd-find \
    ripgrep \
    jq \
    ncdu \
    vim \
    xclip \
    dnsutils \
    git-delta
```

> **Ubuntu quirks** — `bat` installs as `batcat`, `fd` installs as `fdfind`. Fix:
> ```bash
> ln -sf "$(which batcat)" ~/.local/bin/bat
> ln -sf "$(which fdfind)" ~/.local/bin/fd
> ```

## DNF packages (Fedora / RHEL / Rocky)

```bash
sudo dnf install -y \
    git \
    curl \
    stow \
    tmux \
    btop \
    bat \
    fd-find \
    ripgrep \
    jq \
    ncdu \
    vim \
    xclip \
    bind-utils
```

> No naming quirks on Fedora — `bat` and `fd` work as-is.

--- 

## Script-based installs (curl / git)

### starship
```bash
curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
```

### zoxide
```bash
curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

### fzf
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin
ln -sf ~/.fzf/bin/fzf ~/.local/bin/fzf
```

### fzf-git
```bash
mkdir -p ~/.config/fzf-git
curl -fsSL https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh \
    -o ~/.config/fzf-git/fzf-git.sh
```

### zsh-autosuggestions + zsh-syntax-highlighting
```bash
mkdir -p ~/.config/zsh/plugins

git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
    ~/.config/zsh/plugins/zsh-autosuggestions

git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \
    ~/.config/zsh/plugins/zsh-syntax-highlighting
```

---

## GitHub Release installs

Each block is self-contained — paste the whole block at once.

### eza — modern `ls` replacement
- **Releases:** https://github.com/eza-community/eza/releases

```bash
ARCH="$(uname -m)"
URL=$(curl -fsSL "https://api.github.com/repos/eza-community/eza/releases/latest" \
    | grep "browser_download_url" \
    | grep "eza_${ARCH}-unknown-linux-musl.tar.gz\"" \
    | cut -d '"' -f 4)
tmp=$(mktemp -d)
curl -fsSL "$URL" -o "$tmp/eza.tar.gz"
tar -xzf "$tmp/eza.tar.gz" -C "$tmp"
cp "$tmp/eza" ~/.local/bin/eza
rm -rf "$tmp"
```

### delta — better `git diff`
- **Releases:** https://github.com/dandavison/delta/releases

```bash
ARCH="$(uname -m)"
URL=$(curl -fsSL "https://api.github.com/repos/dandavison/delta/releases/latest" \
    | grep "browser_download_url" \
    | grep "${ARCH}-unknown-linux-gnu.tar.gz\"" \
    | cut -d '"' -f 4)
tmp=$(mktemp -d)
curl -fsSL "$URL" -o "$tmp/delta.tar.gz"
tar -xzf "$tmp/delta.tar.gz" -C "$tmp"
find "$tmp" -name delta -type f -exec cp {} ~/.local/bin/delta \;
rm -rf "$tmp"
```


### lazygit — terminal UI for git
- **Releases:** https://github.com/jesseduffield/lazygit/releases

```bash
ARCH="$(uname -m)"; [ "$ARCH" = "aarch64" ] && LG_ARCH="arm64" || LG_ARCH="x86_64"
URL=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
    | grep "browser_download_url" \
    | grep "Linux_${LG_ARCH}.tar.gz\"" \
    | cut -d '"' -f 4)
tmp=$(mktemp -d)
curl -fsSL "$URL" -o "$tmp/lazygit.tar.gz"
tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp"
cp "$tmp/lazygit" ~/.local/bin/lazygit
rm -rf "$tmp"
```

### yazi — terminal file manager
- **Releases:** https://github.com/sxyazi/yazi/releases

```bash
ARCH="$(uname -m)"
URL=$(curl -fsSL "https://api.github.com/repos/sxyazi/yazi/releases/latest" \
    | grep "browser_download_url" \
    | grep "yazi-${ARCH}-unknown-linux-gnu.tar.gz\"" \
    | cut -d '"' -f 4)
tmp=$(mktemp -d)
curl -fsSL "$URL" -o "$tmp/yazi.tar.gz"
tar -xzf "$tmp/yazi.tar.gz" -C "$tmp"
find "$tmp" -name yazi -type f -exec cp {} ~/.local/bin/yazi \;
rm -rf "$tmp"
```

### yq — YAML processor
- **Releases:** https://github.com/mikefarah/yq/releases

```bash
ARCH="$(uname -m)"; [ "$ARCH" = "x86_64" ] && YQ_ARCH="amd64" || YQ_ARCH="arm64"
URL=$(curl -fsSL "https://api.github.com/repos/mikefarah/yq/releases/latest" \
    | grep "browser_download_url" \
    | grep "yq_linux_${YQ_ARCH}\"" \
    | cut -d '"' -f 4)
curl -fsSL "$URL" -o ~/.local/bin/yq
chmod +x ~/.local/bin/yq
```

### fastfetch — system info
- **Releases:** https://github.com/fastfetch-cli/fastfetch/releases

```bash
# Option 2 — dnf (Fedora, works natively)
sudo dnf install -y fastfetch

# Option 3 — GitHub release
ARCH="$(uname -m)"; [ "$ARCH" = "x86_64" ] && FF_ARCH="amd64" || FF_ARCH="arm64"
URL=$(curl -fsSL "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" \
    | grep "browser_download_url" \
    | grep "linux-${FF_ARCH}.deb\"" \
    | cut -d '"' -f 4)
curl -fsSL "$URL" -o /tmp/fastfetch.deb
sudo dpkg -i /tmp/fastfetch.deb
```


## Not available via apt / dnf — summary

| Tool       | apt      | dnf      | Install method         |
|------------|----------|----------|------------------------|
| eza        | ✘        | ✘        | GitHub release         |
| delta      | ✘        | ✘        | GitHub release         |
| lazygit    | ✘        | ✘        | GitHub release         |
| yazi       | ✘        | ✘        | GitHub release         |
| yq         | ✘        | ✘        | GitHub release         |
| starship   | ✘        | ✘        | install script         |
| zoxide     | ✘        | ✘        | install script         |
| fastfetch  | ✘        | ✔        | PPA / GitHub release   |
| fzf        | old ver   | old ver  | git clone recommended  |

### Install NeoVim + lazyvim

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /opt/nvim
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
```
```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
```
```bash
rm -rf ~/.config/nvim/.git
```
```bash
nvim
```

required by *nvim-treesitter*
```bash
:checkhealth nvim-treesitter
```

### Atuin Setup
```bash
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
```

```bash
echo 'eval "$(atuin init bash)"' >> ~/.bashrc
source ~/.bashrc
```

```bash
# atuin (full config auto generates and looks like this)
. "$HOME/.atuin/bin/env"
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"
```

