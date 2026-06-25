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
  rust downgrade
```

---

## 3) LSP & Neovim Tools

```bash
sudo pacman -S --noconfirm --needed \
  gcc make git \
  ripgrep fd unzip \
  rust-analyzer \
  nodejs npm

sudo npm install -g tree-sitter-cli

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

"$schema" = 'https://starship.rs/config-schema.json'

format = """
[](fg:red bg:none)\
$os\
$username\
[](bg:peach fg:red)\
$directory\
[](fg:peach bg:none)\
$fill\
[](fg:yellow bg:none)\
$git_branch\
$git_status\
[](fg:green bg:yellow)\
$c\
$rust\
$golang\
$nodejs\
$bun\
$php\
$java\
$kotlin\
$haskell\
$python\
[](fg:sapphire bg:green)\
$conda\
[](fg:lavender bg:sapphire)\
$time\
[](fg:lavender bg:none)\
$cmd_duration\
$line_break\
$character"""

palette = 'catppuccin_mocha'

[fill]
symbol = " "
style = "bg:none"

[os]
disabled = false
style = "bg:red fg:crust"

[os.symbols]
Windows = ""
Ubuntu = "󰕈"
SUSE = ""
Raspbian = "󰐿"
Mint = "󰣭"
Macos = "󰀵"
Manjaro = ""
Linux = "󰌽"
Gentoo = "󰣨"
Fedora = "󰣛"
Alpine = ""
Amazon = ""
Android = ""
AOSC = ""
Arch = "󰣇"
Artix = "󰣇"
CentOS = ""
Debian = "󰣚"
Redhat = "󱄛"
RedHatEnterprise = "󱄛"

[username]
show_always = true
style_user = "bg:red fg:crust"
style_root = "bg:red fg:crust"
format = '[ $user]($style)'

[directory]
style = "bg:peach fg:crust"
format = "[ $path ]($style)"
truncation_length = 0
truncate_to_repo = false
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = "󰝚 "
"Pictures" = " "
"Developer" = "󰲋 "

[git_branch]
symbol = " "
style = "bg:yellow fg:crust"
format = '[[ $symbol$branch ](fg:crust bg:yellow)]($style)'

[git_status]
style = "bg:yellow fg:crust"
format = '[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)'

[nodejs]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[bun]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[c]
symbol = " "
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[rust]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[golang]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[php]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[java]
symbol = " "
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[kotlin]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[haskell]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[python]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version)(\(#$virtualenv\)) ](fg:crust bg:green)]($style)'

[docker_context]
symbol = ""
style = "bg:sapphire"
format = '[[ $symbol( $context) ](fg:crust bg:sapphire)]($style)'

[conda]
symbol = "  "
style = "fg:crust bg:sapphire"
format = '[$symbol$environment ]($style)'
ignore_base = false

[time]
disabled = false
time_format = "%R"
style = "bg:lavender fg:crust"
format = '[[   $time ](fg:crust bg:lavender)]($style)'

[character]
disabled = false
success_symbol = '[❯](bold fg:green)'
error_symbol = '[❯](bold fg:red)'
vimcmd_symbol = '[❮](bold fg:green)'
vimcmd_replace_one_symbol = '[❮](bold fg:lavender)'
vimcmd_replace_symbol = '[❮](bold fg:lavender)'
vimcmd_visual_symbol = '[❮](bold fg:yellow)'

[cmd_duration]
show_milliseconds = true
style = "fg:lavender bg:none"
# format = " in $duration "
format = " in [$duration]($style)"
disabled = false
show_notifications = true
min_time_to_notify = 45000

# Palette Colors Definitions
[palettes.catppuccin_mocha]
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"
text = "#cdd6f4"
subtext1 = "#bac2de"
subtext0 = "#a6adc8"
overlay2 = "#9399b2"
overlay1 = "#7f849c"
overlay0 = "#6c7086"
surface2 = "#585b70"
surface1 = "#45475a"
surface0 = "#313244"
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"


[palettes.catppuccin_frappe]
rosewater = "#f2d5cf"
flamingo = "#eebebe"
pink = "#f4b8e4"
mauve = "#ca9ee6"
red = "#e78284"
maroon = "#ea999c"
peach = "#ef9f76"
yellow = "#e5c890"
green = "#a6d189"
teal = "#81c8be"
sky = "#99d1db"
sapphire = "#85c1dc"
blue = "#8caaee"
lavender = "#babbf1"
text = "#c6d0f5"
subtext1 = "#b5bfe2"
subtext0 = "#a5adce"
overlay2 = "#949cbb"
overlay1 = "#838ba7"
overlay0 = "#737994"
surface2 = "#626880"
surface1 = "#51576d"
surface0 = "#414559"
base = "#303446"
mantle = "#292c3c"
crust = "#232634"

[palettes.catppuccin_latte]
rosewater = "#dc8a78"
flamingo = "#dd7878"
pink = "#ea76cb"
mauve = "#8839ef"
red = "#d20f39"
maroon = "#e64553"
peach = "#fe640b"
yellow = "#df8e1d"
green = "#40a02b"
teal = "#179299"
sky = "#04a5e5"
sapphire = "#209fb5"
blue = "#1e66f5"
lavender = "#7287fd"
text = "#4c4f69"
subtext1 = "#5c5f77"
subtext0 = "#6c6f85"
overlay2 = "#7c7f93"
overlay1 = "#8c8fa1"
overlay0 = "#9ca0b0"
surface2 = "#acb0be"
surface1 = "#bcc0cc"
surface0 = "#ccd0da"
base = "#eff1f5"
mantle = "#e6e9ef"
crust = "#dce0e8"

[palettes.catppuccin_macchiato]
rosewater = "#f4dbd6"
flamingo = "#f0c6c6"
pink = "#f5bde6"
mauve = "#c6a0f6"
red = "#ed8796"
maroon = "#ee99a0"
peach = "#f5a97f"
yellow = "#eed49f"
green = "#a6da95"
teal = "#8bd5ca"
sky = "#91d7e3"
sapphire = "#7dc4e4"
blue = "#8aadf4"
lavender = "#b7bdf8"
text = "#cad3f5"
subtext1 = "#b8c0e0"
subtext0 = "#a5adcb"
overlay2 = "#939ab7"
overlay1 = "#8087a2"
overlay0 = "#6e738d"
surface2 = "#5b6078"
surface1 = "#494d64"
surface0 = "#363a4f"
base = "#24273a"
mantle = "#1e2030"
crust = "#181926"
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

# =========================
# 1. FZF CONFIG
# =========================

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# =========================
# 2. IME (Fcitx5)
# =========================

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx


# =========================
# 3. HISTORY (ADD THIS - IMPORTANT)
# =========================

HISTSIZE=10000
SAVEHIST=20000
HISTFILE="$HOME/.zsh_history"

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS


# =========================
# 4. TMUX (SAFE + MANUAL CONTROL)
# =========================

# Manual aliases (recommended)
alias t='tmux'
alias ta='tmux attach || tmux new-session -s main'

# OPTIONAL AUTO-START (disabled by default)
# Uncomment if you want terminal to always open in tmux:
#
# if command -v tmux >/dev/null 2>&1; then
#   if [ -z "$TMUX" ]; then
#     tmux attach-session -t main 2>/dev/null || tmux new-session -s main
#   fi
# fi


# =========================
# 5. USEFUL SHELL BEHAVIOR
# =========================

setopt AUTO_CD
setopt CORRECT
setopt INTERACTIVE_COMMENTS


# =========================
# 6. COMPLETION SYSTEM
# =========================

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select


# =========================
# 7. ALIASES
# =========================

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'


# =========================
# 8. PATH
# =========================

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"


# =========================
# 9. STARSHIP PROMPT (MUST BE LAST)
# =========================

eval "$(starship init zsh)"

# =========================
# 10. FIX HOME / END / DELETE KEYS
# =========================

# Home
bindkey "^[[H" beginning-of-line
bindkey "^[OH" beginning-of-line

# End
bindkey "^[[F" end-of-line
bindkey "^[OF" end-of-line

# Delete
bindkey "^[[3~" delete-char
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
