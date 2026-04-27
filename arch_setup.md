# Arch Linux Post-Install Setup

## 0) Base Setup (Shell & AUR Helper)

```bash
# Install dependencies
sudo pacman -Syu --needed base-devel git zsh

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si && cd .. && rm -rf yay

# Set Zsh as default shell
chsh -s $(which zsh)
```

## 1) System tools

```bash
sudo pacman -S --needed \
  fastfetch glances \
  wget unzip nano \
  usbutils wl-clipboard
```

## 2) Development tools

```bash
sudo pacman -S --needed \
  jdk-openjdk maven \
  rust nodejs npm \
  downgrade
```

## 3) LSP & Neovim Tools

```bash
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
sudo pacman -S rust-analyzer
yay -S jdtls
```

## 4) GUI Apps

```bash
# Official Repos
sudo pacman -S --needed \
  dolphin konsole pavucontrol \
  alsa-utils pipewire-alsa

# AUR
yay -S vesktop google-chrome

git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -si
```

## 5) Fonts

```bash
sudo pacman -S --needed \
  ttf-jetbrains-mono-nerd \
  ttf-cascadia-code-nerd \
  noto-fonts-cjk
```

## 6) IME (Fcitx5)

```bash
sudo pacman -S --needed \
  fcitx5 fcitx5-configtool \
  fcitx5-gtk fcitx5-rime
```

**Config:** Add to `~/.bashrc` or `~/.zshrc`:

```bash
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

Enable:

```bash
fcitx5 &
```

## 7) Downgrade Neovim / Tree-sitter

```bash
# Select: neovim (0.11.7) | tree-sitter (0.25.7)
sudo downgrade neovim tree-sitter

# Prevent auto-updates
sudo nano /etc/pacman.conf
```

Add the following to the `[options]` section:

```ini
IgnorePkg = neovim tree-sitter
```

## 8) Verify

```bash
java -version && mvn -version
cargo --version
node -v && npm -v
zsh --version
yay --version
```
