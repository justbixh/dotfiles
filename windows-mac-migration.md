###### Quick bulk-install (edit list before running)

```bash
# run
brew bundle --file=Brewfile
```


```ruby
# Brewfile
# commented tools are not to be installed 

# --- terminal ---
cask "wezterm"
cask "termius"

# --- notes ---
cask "obsidian"
cask "notion"
cask "todoist"
cask "sublime-text"
tap "zennotes/tap"
cask "zennotes/tap/zennotes"

# --- editors ---
cask "intellij-idea-ce"
cask "antigravity-ide"
cask "visual-studio-code"
cask "zed"
cask "sublime-merge"

# --- databases ---
cask "dbeaver-community"
# cask "datagrip"

# --- utils ---
# cask "raycast" # https://www.raycast.com/
cask "maccy" # https://github.com/p0deje/Maccy/blob/master/README.md#usage

# --- web ---
cask "claude"
cask "chatgpt"
cask "google-chrome"
cask "arc"

# --- containers ---
cask "docker"
brew "lazydocker"

# --- Shell / dotfiles / core CLI ---
brew "starship"
brew "stow"
brew "git"
brew "eza"
brew "fzf"
brew "tmux"
brew "bat"
brew "fd"
brew "ripgrep"
brew "zoxide"
brew "yazi"
brew "btop"
brew "ctop"
brew "ncdu"
brew "jq"
brew "yq"
brew "fastfetch"
brew "pfetch"
brew "git-delta"
brew "lazygit"
# fzf-git requires manual install
# brew "atuin"

# --- Kubernetes / GitOps ---
# brew "kubectl"
# brew "helm"
# brew "k9s"
# brew "kubectx"
# brew "argocd"

# --- Kafka ---
# brew "kafka"
# brew "awscli"

# --- java ---
# sdkman: curl -s "https://get.sdkman.io" | bash
```

###### Direct LazyVim install

Since LazyVim itself isn't a brew package, here's the actual install sequence:

```bash
# 1. Install Neovim + the tools LazyVim expects
brew install neovim git ripgrep fd lazygit fzf tree-sitter

# 2. Back up any existing nvim config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null
mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null

# 3. Clone the LazyVim starter template
git clone https://github.com/LazyVim/starter ~/.config/nvim

# 4. Remove the starter's .git so you can track it in your own dotfiles repo instead
rm -rf ~/.config/nvim/.git

# 5. Launch — plugins install automatically on first run
nvim
```


###### Development Tools

| App (Windows)          | Homebrew (macOS)                                           | Winget (Windows)             | Notes                                                                                                    |
| ---------------------- | ---------------------------------------------------------- | ---------------------------- | -------------------------------------------------------------------------------------------------------- |
| **IntelliJ IDEA**      | `brew install --cask intellij-idea-ce`                     | `JetBrains.IntelliJIDEA`     | JetBrains Toolbox (`brew install --cask jetbrains-toolbox`) is easier if you use multiple JetBrains IDEs |
| **Antigravity IDE**    | `brew install --cask antigravity-ide`                      | `Google.AntigravityIDE`      |                                                                                                          |
| **Visual Studio Code** | `brew install --cask visual-studio-code`                   | `Microsoft.VisualStudioCode` | Settings Sync carries your extensions/keybindings over                                                   |
| **Docker Desktop**     | `brew install --cask docker`                               | `Docker.DockerDesktop`       | On Apple Silicon, images build for arm64 by default — use `--platform linux/amd64` when you need x86     |
| **DBeaver Community**  | `brew install --cask dbeaver-community`                    | `DBeaver.DBeaver.Community`  |                                                                                                          |
| **DataGrip**           | `brew install --cask datagrip`                             | `JetBrains.DataGrip`         |                                                                                                          |
| Google Antigravity     | `brew install --cask antigravity`                          | `Google.Antigravity`         |                                                                                                          |
| GitKraken              | `brew install --cask gitkraken`                            | `Axosoft.GitKraken`          |                                                                                                          |
| Python                 | `brew install python@3.13` (or `pyenv` to manage versions) | `Python.Python.3.6`          | Your Windows version (3.6) is very old — use `pyenv install` on Mac to manage versions cleanly           |
| RunJS                  | `brew install --cask runjs`                                | `lukehaas.RunJS`             |                                                                                                          |
| Node.js                | `brew install node`                                        | `OpenJS.NodeJS.22`           | Consider `brew install nvm` instead for version switching                                                |
| **Sublime Merge**      |                                                            |                              | Git Client                                                                                               |
| **Zed**                |                                                            |                              |                                                                                                          |
| **Claude** (desktop)   | `brew install --cask claude`                               | `Anthropic.Claude`           |                                                                                                          |
| **ChatGPT** (desktop)  | `brew install --cask chatgpt`                              | (Microsoft Store / MSIX)     |                                                                                                          |


###### Terminal, Shell & CLI

| App (Windows)                   | Homebrew (macOS)                                                     | Winget (Windows)        | Notes                                                                                                                     |
| ------------------------------- | -------------------------------------------------------------------- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **WezTerm**                     | `brew install --cask wezterm`                                        | `wez.wezterm`           | Same config format — your dotfiles config should mostly just work                                                         |
| PowerShell 7                    | `brew install --cask powershell`                                     | `Microsoft.PowerShell`  | Only if you want `pwsh` on Mac too — most people switch to zsh full-time                                                  |
| btop4win                        | `brew install btop`                                                  | `aristocratos.btop4win` | Same project, native on macOS                                                                                             |
| eza                             | `brew install eza`                                                   | `eza-community.eza`     | Already in your dotfiles stack                                                                                            |
| MobaXterm                       | —                                                                    | `Mobatek.MobaXterm`     | **Alt:** you don't need it on Mac — native Terminal/WezTerm + `ssh`/`sshfs` cover this. Termius also works cross-platform |
| **Termius**                     | `brew install --cask termius`                                        | `Termius.Termius`       | You're already using this                                                                                                 |
| *SSHFS-Win / SSHFS-Win Manager* | `brew install --cask macfuse && brew install gromgit/fuse/sshfs-mac` | `SSHFS-Win.SSHFS-Win`   | macFUSE requires enabling a kernel extension in System Settings once                                                      |

###### Databases **will use docker for this**

| App (Windows)                 | Homebrew (macOS)                      | Winget (Windows, ref)   | Notes                                                                              |
| ----------------------------- | ------------------------------------- | ----------------------- | ---------------------------------------------------------------------------------- |
| MongoDB Compass               | `brew install --cask mongodb-compass` | `MongoDB.Compass.Full`  |                                                                                    |
| MongoDB Shell (mongosh)       | `brew install mongosh`                | `MongoDB.Shell`         |                                                                                    |
| MySQL Workbench               | `brew install --cask mysqlworkbench`  | `Oracle.MySQLWorkbench` |                                                                                    |
| MySQL Server/Router/Installer | `brew install mysql`                  | `Oracle.MySQL`          | On Mac you install MySQL itself directly rather than through an "Installer" wizard |



###### Browsers, Communication & Productivity

| App (Windows)                | Homebrew (macOS)                                 | Winget (Windows, ref)            | Notes                                                                                                                      |
| ---------------------------- | ------------------------------------------------ | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **Google Chrome**            | `brew install --cask google-chrome`              | `Google.Chrome.EXE`              |                                                                                                                            |
| Google Drive                 | `brew install --cask google-drive`               | `Google.GoogleDrive`             |                                                                                                                            |
| Microsoft OneDrive           | `brew install --cask onedrive`                   | `Microsoft.OneDrive`             |                                                                                                                            |
| WhatsApp                     | `brew install --cask whatsapp`                   | `9NKSQGP7F2NH` (MS Store)        |                                                                                                                            |
| Zoom                         | `brew install --cask zoom`                       | `Zoom.Zoom.EXE`                  |                                                                                                                            |
| **Notion**                   | `brew install --cask notion`                     | `Notion.Notion`                  |                                                                                                                            |
| **Obsidian**                 | `brew install --cask obsidian`                   | `Obsidian.Obsidian`              | Point it at your existing `my-brain-26` vault folder (via iCloud/Drive/Syncthing) and it picks up right where you left off |
| **Todoist**                  | `brew install --cask todoist`                    | `XP99K37G9CWBDC` (MS Store)      |                                                                                                                            |
| Grammarly                    | `brew install --cask grammarly-desktop`          | `Grammarly.Grammarly`            |                                                                                                                            |
| Chrome Remote Desktop (host) | `brew install --cask chrome-remote-desktop-host` | `Google.ChromeRemoteDesktopHost` |                                                                                                                            |
| Adobe Acrobat Reader         | `brew install --cask adobe-acrobat-reader`       | (MSIX)                           |                                                                                                                            |
| Wondershare PDFelement       | `brew install --cask pdfelement`                 | `Wondershare.PDFelement.9`       |                                                                                                                            |
| PairDrop / Snapdrop          | — (web apps)                                     | —                                | Both are just websites, no install needed on either OS — for native Mac↔Mac, AirDrop replaces this entirely                |
| mymind                       | — (web app)                                      | —                                |                                                                                                                            |
| PowerToys module       | `brew install --cask raycast` or `alfred`                  | `Powertoyz.powertoyz`        |                                                                                                          |

###### Media, Audio & Video

| App (Windows)                                                 | Homebrew (macOS)                                                  | Winget (Windows, ref)             | Notes                                                                                                                                                         |
| ------------------------------------------------------------- | ----------------------------------------------------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| VLC                                                           | `brew install --cask vlc`                                         | `VideoLAN.VLC`                    |                                                                                                                                                               |
| HandBrake                                                     | `brew install --cask handbrake`                                   | `HandBrake.HandBrake`             |                                                                                                                                                               |
| OBS Studio                                                    | `brew install --cask obs`                                         | `OBSProject.OBSStudio`            |                                                                                                                                                               |
| 4K Video Downloader+                                          | `brew install --cask 4k-video-downloader-plus`                    | `OpenMedia.4KVideoDownloaderPlus` |                                                                                                                                                               |
| YouTube Music (desktop)                                       | `brew install --cask ytmdesktop-youtube-music`                    | (none, custom install)            | Community-maintained unofficial client                                                                                                                        |
| Mechvibes                                                     | `brew install --cask mechvibes`                                   | `HaiNguyen.Mechvibes`             |                                                                                                                                                               |
| AIMP                                                          | **Not on Homebrew / no macOS build**                              | `AIMP.AIMP`                       | **Alt:** Swinsian or Nightingale (paid) for a similar library-style player; or Music.app                                                                      |
| HD Video Converter Factory Pro                                | **Windows-only**                                                  | (no winget id)                    | **Alt:** HandBrake covers most conversion needs; Permute is a nice paid Mac-native option                                                                     |
| Digital Anarchy Flicker Free (AE plugin)                      | — (direct download)                                               | (no winget id)                    | Download the macOS installer directly from Digital Anarchy                                                                                                    |
| Magic Bullet Suite / VFX Suite (Red Giant)                    | — (direct download)                                               | (no winget id)                    | Install via Maxon/Red Giant app: `brew install --cask maxon-app` gets you the license manager                                                                 |
| Neat Image (Photoshop plugin)                                 | — (direct download)                                               | (no winget id)                    |                                                                                                                                                               |
| Valhalla DSP plugins (VintageVerb, Room, Plate, Supermassive) | — (direct download)                                               | (no winget id)                    | Download AU/VST versions directly from valhalladsp.com                                                                                                        |
| Cronometer                                                    | **Not on Homebrew**                                               | (no winget id)                    | Use the web app, or the iOS app if you're on iPhone too                                                                                                       |
| 7-Zip                                                         | `brew install --cask keka` (GUI) or `brew install sevenzip` (CLI) | `7zip.7zip`                       | Keka is the closest GUI equivalent; also opens RAR/7z/etc.                                                                                                    |
| WinRAR                                                        | `brew install --cask keka`                                        | `RARLab.WinRAR`                   | Keka covers RAR extraction too                                                                                                                                |
| Notepad++                                                     | — (Windows-only)                                                  | `Notepad++.Notepad++`             | **Alt:** VS Code, Sublime Text (`brew install --cask sublime-text`), or BBEdit for lightweight native editing                                                 |
| ShareX                                                        | — (Windows-only)                                                  | `ShareX.ShareX`                   | **Alt:** CleanShot X (`brew install --cask cleanshot`, paid, very good) or Shottr (`brew install --cask shottr`, free)                                        |
| PowerToys                                                     | — (Windows-only)                                                  | `XP89DCGQ3K6VLD` (MS Store)       | **Alt:** most PowerToys modules have separate Mac equivalents — Raycast/Alfred for Command Palette+Run, Rectangle for FancyZones, Maccy for clipboard history |
| WizTree                                                       | — (Windows-only)                                                  | `AntibodySoftware.WizTree`        | **Alt:** `brew install --cask grandperspective` (free) or DaisyDisk (`brew install --cask daisydisk`, paid, nicer UI)                                         |
| Revo Uninstaller                                              | — (Windows-only)                                                  | `RevoUninstaller.RevoUninstaller` | **Alt:** `brew install --cask appcleaner` (free) does the same job — removes leftover files when you drag an app to Trash                                     |
| Excalidraw (desktop)                                          | — (web app)                                                       | (no winget id)                    | No official desktop app on either OS — install as a browser PWA                                                                                               |
| EarTrumpet                                                    | Per-app volume mixer for Windows                                  |                                   | macOS doesn't have per-app volume natively; `brew install --cask background-music` is the closest open-source equivalent                                      |


