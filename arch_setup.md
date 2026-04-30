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
```

Install Java LSP:

```bash
yay -S jdtls
yay -S neovim-git
```

---

## 4) CLI Power Tools (fzf stack)

```bash
sudo pacman -S --needed \
  fzf fd ripgrep bat
```

### Enable fzf in Zsh

Add to `~/.zshrc`:

```bash
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

Apply:

```bash
source ~/.zshrc
```

---

## 5) Starship Prompt

Install:

```bash
sudo pacman -S starship
```

Enable in `~/.zshrc`:

```bash
eval "$(starship init zsh)"
```

### Config file

Create:

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

## 6) GUI Apps

```bash
# Official Repos
sudo pacman -S --needed \
  dolphin pavucontrol \
  alsa-utils pipewire-alsa
```

```bash
# AUR apps
yay -S vesktop google-chrome
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -si
```

---

## 7) Fonts (Required for icons)

```bash
sudo pacman -S --needed \
  ttf-jetbrains-mono-nerd \
  ttf-cascadia-code-nerd \
  noto-fonts-cjk
```

---

## 8) IME (Fcitx5)

```bash
sudo pacman -S --needed \
  fcitx5 fcitx5-configtool \
  fcitx5-gtk fcitx5-rime
```

### Environment variables

Add to `~/.zshrc`:

```bash
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

Start manually (or autostart later):

```bash
fcitx5 &
```

---

## 9) Terminal Emulator (Alacritty)

Install:

```bash
sudo pacman -S alacritty
```

Config file:

```bash
mkdir -p ~/.config/alacritty
nano ~/.config/alacritty/alacritty.toml
```

### Config

```toml
[general]
live_config_reload = true

[window]
padding = { x = 12, y = 12 }
opacity = 0.90
startup_mode = "Windowed"

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
  { key = "End", mods = "Control|Shift", action = "ScrollToBottom" }
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
```

---
