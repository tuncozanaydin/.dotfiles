# .dotfiles Setup

## 1. Partition the Disk

Before installing Ubuntu, manually partition the main drive using `cgdisk`:

```bash
sudo cgdisk /dev/nvme0n1
```

Create two partitions:

1. **Root (`/`)**
   - Size: **128G**
   - Type: `8300 Linux filesystem`
   - Mount point: `/`

2. **Home (`/home`)**
   - Size: **remaining space**
   - Type: `8300 Linux filesystem`
   - Mount point: `/home`

Write the changes and quit `cgdisk`.

---

## 2. Install Ubuntu

Proceed with a standard Ubuntu installation.
When prompted for partitioning:
- Choose **“Something else”**.
- Assign the partitions as created above:
  - `/` → ext4, mounted at `/`
  - `/home` → ext4, mounted at `/home`
- Continue installation normally.

---

## 3. Enable Password-Free `sudo`

After installation, log in as your user and run:

```bash
sudo visudo
```

Find the line:

```
%sudo   ALL=(ALL:ALL) ALL
```

Add the following line below it (replace `yourusername`):

```
yourusername ALL=(ALL) NOPASSWD:ALL
```

Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X` in nano).

---

## 4. Install Core Packages

```bash
sudo apt update
sudo apt install -y git wget mplayer openssh-server gnome-shell-extension-manager nvtop htop pass
```

Enable SSH for remote access:

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

---

## 5. Install Snap Packages

```bash
sudo snap install emacs --classic
sudo snap install brave
sudo snap install spotify
```

---

## 6. Install Kitty Terminal

```bash
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

---

## 7. Install Dropbox

Follow the official instructions: <https://www.dropbox.com/install-linux>

```bash
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
```


---

## 8. Clone and Link Dotfiles

Once Dropbox has finished syncing, clone your personal dotfiles repository:

```bash
cd ~
git clone git@github.com:tuncozanaydin/.dotfiles.git
```

Create symlinks:

```bash
ln -s ~/.dotfiles/.emacs.d ~/.emacs.d
mkdir -p ~/.config/kitty
ln -s ~/.dotfiles/kitty.conf ~/.config/kitty/
```

---

## 9. GNOME Extensions (after cloning dotfiles)

Launch the extension manager:

```bash
gnome-shell-extension-manager
```

Then:
- **Disable**: Desktop Icons, Ubuntu Dock, Ubuntu Tiling Assistant  
- **Install**: **Tiling Shell** extension  
- **Import settings**: Use the gear/menu in Extension Manager to **Import** from:  
  `~/.dotfiles/tilingshell-settings.txt`

---

## 10. GNOME Appearance & Behavior

Set dark mode and wallpaper:

```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Dropbox/wallpaper/your_image.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Dropbox/wallpaper/your_image.jpg"
```

Workspaces: fixed number (1 total):

```bash
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 1
```

Power & performance:

```bash
# Performance mode (if supported by power-profiles-daemon)
powerprofilesctl set performance || true

# Keep system awake on AC (no auto-suspend)
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0

# Screen blank after 10 minutes (600 seconds)
gsettings set org.gnome.desktop.session idle-delay 600
```

Reduce animations & tune key repeat:

```bash
# Reduce motion
gsettings set org.gnome.desktop.interface enable-animations false

# Key repeat: roughly mid values; adjust to taste
gsettings set org.gnome.desktop.peripherals.keyboard delay 300       # ms
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 25  # ms
```

Add your Google account:

- **Settings → Online Accounts → Google** and sign in (Drive/Calendar/Contacts integration).

---

## 11. Sync Passwords, Fonts, and Wallpaper

Link password store (used by `pass` and `passforios`):

```bash
ln -s ~/Dropbox/.password_store ~/
```

Link custom fonts and refresh font cache:

```bash
cd ~/.local/share
ln -s ~/Dropbox/fonts .
fc-cache -fv
```

(If you haven't set a specific wallpaper file yet, choose one under `~/Dropbox/wallpaper/` and re-run the wallpaper command above.)

---

## 12. Install Conda

Install Miniconda locally under your home directory:

```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```

Activate Conda and initialize for all shells:

```bash
source ~/miniconda3/bin/activate
conda init --all
```

Then restart your terminal or run:

```bash
source ~/.bashrc
```

---

## 13. Generate SSH Keys

Generate a new SSH key for the current machine:

```bash
ssh-keygen -t ed25519 -C "tunc@<machine-name>"
```

The key will be saved to `~/.ssh/id_ed25519` by default.

Display the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Upload it to:
- GitHub: https://github.com/settings/keys
- GitLab: https://gitlab.com/-/profile/keys

Propagate this key to other machines you access:

```bash
ssh-copy-id <other-machine-name-or-ip>
```

Also, from other machines that need access **to this one**, run on those machines:

```bash
ssh-copy-id <this-machine-name-or-ip>
```

---

## 14. Import GPG Key

Import your private GPG key (for password store or commits):

```bash
gpg --allow-secret-key-import --import private.key
```

Verify:

```bash
gpg --list-keys
```

Edit and trust key:

```bash
gpg --edit-key [KEYID]
trust
save
```

---

## 15. Set Up Printer (ETH Zurich Network Printer)

Install required packages:

```bash
sudo apt install smbclient system-config-printer cups
```

Start the printer configuration tool:

```bash
system-config-printer
```

Then:
1. **Add → Network Printer → Windows Printer via SAMBA**
2. **Device URI:** `smb://drz-moog.d.ethz.ch/drz-std4-20-hpm551`
3. **Authentication:**
   - **Username:** `d\taydin`
   - **Password:** `eth/nethz`
4. **Driver:** <https://wiki.drz.li/drz-std4-20-hpm551.ppd>

Print a test page to confirm setup.

---
