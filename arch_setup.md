## 0) System tools

```bash
sudo pacman -S --needed \
  fastfetch glances \
  wget unzip nano \
  usbutils wl-clipboard
```

---

## 1) Development tools

```bash
sudo pacman -Syu

sudo pacman -S --needed \
  jdk-openjdk \
  maven \
  rust \
  nodejs npm \
  downgrade
```

---

## 2) LSP

```bash
yay -S jdtls
```

```bash
sudo pacman -S rust-analyzer
```

---

## 3) GUI apps

```bash
sudo pacman -S --needed \
  dolphin \
  konsole \
  pavucontrol \
  alsa-utils \
  pipewire-alsa
```

AUR:

```bash
yay -S vesktop
```
```bash
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -si
```

---

## 4) Fonts

```bash
sudo pacman -S --needed \
  ttf-jetbrains-mono-nerd \
  ttf-cascadia-code-nerd \
  noto-fonts-cjk
```

---

## 5) IME (Fcitx5)

```bash
sudo pacman -S --needed \
  fcitx5 \
  fcitx5-configtool \
  fcitx5-gtk \
  fcitx5-rime
```

### Config

Add to `~/.bashrc` or `~/.zshrc`:

```bash
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

Enable:

```bash
fcitx5 &
```

---

## 6) Verify

```bash
java -version
javac -version
mvn -version
cargo --version
node -v
npm -v
```

---

## 7) Downgrade Neovim / tree-sitter

```bash
sudo downgrade neovim
sudo downgrade tree-sitter
```

Select:
- neovim → 0.11.7
- tree-sitter → 0.25.7

---

## 8) Prevent updates

```bash
sudo nano /etc/pacman.conf
```

```ini
IgnorePkg = neovim tree-sitter
```
