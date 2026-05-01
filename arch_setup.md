# Arch Linux Post-Install Setup (Power User Rice)

---

## 0) Base Setup (Shell & AUR Helper)

```bash
# System update + base tools
sudo pacman -Syu --needed base-devel git zsh

# Install yay (AUR helper)
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si && cd .. && rm -rf yay

# Set Zsh as default shell
chsh -s $(which zsh)
```

---

## 1) System tools

```bash
sudo pacman -S --needed \
  fastfetch glances \
  wget unzip nano \
  usbutils wl-clipboard
```

---

## 2) Development tools

```bash
sudo pacman -S --needed \
  jdk-openjdk maven \
  rust nodejs npm \
  downgrade
```

---

## 3) LSP & Neovim Tools

```bash
sudo pacman -S --noconfirm --needed \
  gcc make git \
  ripgrep fd unzip \
  rust-analyzer

# Install Java LSP and Neovim Git
yay -S jdtls neovim-git
```

---

## 4) CLI Power Tools (fzf stack)

```bash
sudo pacman -S --needed \
  fzf fd ripgrep bat
```

---

## 5) Starship Prompt

```bash
sudo pacman -S starship
```

### Config file

```bash
mkdir -p ~/.config
nano ~/.config/starship.toml
```

Paste:

```toml
add_newline = false

format = """
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$rust\
$golang\
$cmd_duration\
$line_break\
$character
"""

[directory]
style = "bold cyan"
truncation_length = 3

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "red"

[nodejs]
symbol = " "

[python]
symbol = "🐍 "

[rust]
symbol = "🦀 "

[golang]
symbol = " "

[cmd_duration]
min_time = 500
format = "⏱ [$duration](yellow)"
```

---

## 6) Tmux Setup

```bash
sudo pacman -S tmux
```

### Config file (`~/.tmux.conf`)

```tmux
# change prefix from Ctrl+b → Ctrl+a (more ergonomic)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# split panes (vim-style)
bind | split-window -h
bind - split-window -v
bind x kill-pane
bind & kill-window
bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

# reload config
bind r source-file ~/.tmux.conf \; display "Reloaded!"

# enable mouse (very important)
set -g mouse on

# faster pane switching
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# better colors
set -g default-terminal "screen-256color"

# status bar
set -g status-bg black
set -g status-fg white
set -g status-left "#S"
set -g status-right "%Y-%m-%d %H:%M | #(whoami)"

# Session management
bind s choose-session
bind w choose-window

# start numbering at 1
set -g base-index 1
setw -g pane-base-index 1
set -g automatic-rename on
set -g remain-on-exit off

# --- Auto-hide status bar for Neovim ---

# Check if the current pane is running Neovim
is_nvim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

# Hook to turn status off when focusing an nvim pane
set-hook -g pane-focus-in "if-shell \"$is_nvim\" 'set status off' 'set status on'"

# Hook to ensure status comes back when switching windows or panes
set-hook -g after-select-window "if-shell \"$is_nvim\" 'set status off' 'set status on'"
set-hook -g after-select-pane "if-shell \"$is_nvim\" 'set status off' 'set status on'"

# Ensure status is on by default when tmux starts
set -g status on
```

---

## 7) Zsh Shell Integration

Add the following to your `~/.zshrc`:

```bash
# 1. fzf logic
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# 2. IME (Fcitx5) environment
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# 3. Tmux Autostart
if command -v tmux >/dev/null 2>&1; then
  # start tmux automatically if not already inside tmux
  if [ -z "$TMUX" ]; then
    tmux attach-session -t main 2>/dev/null || tmux new-session -s main
  fi
fi

# 4. Starship Prompt (Must be at the very bottom)
eval "$(starship init zsh)"
```

Apply:

```bash
source ~/.zshrc
```

---

## 8) GUI Apps

```bash
# Official Repos
sudo pacman -S --needed \
  dolphin pavucontrol \
  alsa-utils pipewire-alsa

# AUR apps
yay -S vesktop google-chrome

cd google-chrome
makepkg -si
```

---

## 9) Fonts (Required for icons)

```bash
sudo pacman -S --needed \
  ttf-jetbrains-mono-nerd \
  ttf-cascadia-code-nerd \
  noto-fonts-cjk
```

---

## 10) IME (Fcitx5)

```bash
sudo pacman -S --needed \
  fcitx5 fcitx5-configtool \
  fcitx5-gtk fcitx5-rime
```

Start manually (or autostart later):

```bash
fcitx5 &
```

---

## 11) Terminal Emulator (Alacritty)

```bash
sudo pacman -S alacritty
mkdir -p ~/.config/alacritty
nano ~/.config/alacritty/alacritty.toml
```

Paste:

```toml
# ~/.config/alacritty/alacritty.toml

[general]
live_config_reload = true

[window]
# padding = { x = 12, y = 12 }
opacity = 1.00
startup_mode = "Windowed"

[window.padding]
x = 0
y = 0

[font]
size = 13

[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Regular"

[scrolling]
history = 10000
multiplier = 3

[cursor]
style = { shape = "Block", blinking = "Off" }

[selection]
save_to_clipboard = true

[env]
TERM = "xterm-256color"

[keyboard]
bindings = [
  { key = "Return", mods = "Control|Shift", action = "SpawnNewInstance" },
  { key = "K", mods = "Control|Shift", action = "ClearHistory" },
  { key = "Home", mods = "Control|Shift", action = "ScrollToTop" },
  { key = "End", mods = "Control|Shift", action = "ScrollToBottom" },
  { key = "F11", action = "ToggleFullscreen" }
]

[colors.primary]
background = "#1a1b26"
foreground = "#c0caf5"

[colors.normal]
black = "#15161e"
red = "#f7768e"
green = "#9ece6a"
yellow = "#e0af68"
blue = "#7aa2f7"
magenta = "#bb9af7"
cyan = "#7dcfff"
white = "#a9b1d6"

[colors.bright]
black = "#414868"
red = "#f7768e"
green = "#9ece6a"
yellow = "#e0af68"
blue = "#7aa2f7"
magenta = "#bb9af7"
cyan = "#7dcfff"
white = "#c0caf5"
```

---

## Verify Everything

```bash
java -version && mvn -version
cargo --version
node -v && npm -v
zsh --version
yay --version
fzf --version
starship --version
tmux -V
```
