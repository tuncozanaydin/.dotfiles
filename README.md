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

## 6. Disable Sleep While Plugged In

To prevent the system from sleeping while on AC power (useful for remote jobs):

```bash
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
```

---

## 7. Configure GNOME Extensions

Launch the extension manager:

```bash
gnome-shell-extension-manager
```

Then:
- **Disable**: Desktop Icons, Ubuntu Dock, Ubuntu Tiling Assistant  
- **Install**: Tiling Shell Extension  
- Import your saved settings via the extension manager’s gear menu.

---

## 8. Set Up GNOME Online Accounts

Open **Settings → Online Accounts** and add your **personal Google account**.
This enables Google Drive access and calendar integration in GNOME.

---

## 9. Install Kitty Terminal

```bash
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

---

## 10. Install Dropbox

Follow the official instructions: <https://www.dropbox.com/install-linux>

```bash
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
```

After starting Dropbox, sign in and wait for the `~/Dropbox` folder to sync your `.dotfiles` directory.

---

## 11. Clone and Link Dotfiles

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

## 12. Sync Passwords, Fonts, and Wallpaper

Link password store (used by `pass` and `passforios`):

```bash
ln -s ~/Dropbox/.password_store ~/
```

Set wallpaper:

```bash
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Dropbox/wallpaper/"
```

Link custom fonts and refresh font cache:

```bash
mkdir -p ~/.local/share/fonts
ln -s ~/Dropbox/fonts ~/.local/share/fonts
fc-cache -fv
```

---

## 13. Install Conda

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

## 14. Generate SSH Keys

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
- [GitHub SSH Keys](https://github.com/settings/keys)
- [GitLab SSH Keys](https://gitlab.com/-/profile/keys)

---

## 15. Import GPG Key

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

## 16. Set Up Printer (ETH Zurich Network Printer)

Install required packages:

```bash
sudo apt install smbclient system-config-printer cups
```

Start the printer configuration tool:

```bash
system-config-printer
```

Then:
1. Choose **Add → Network Printer → Windows Printer via SAMBA**
2. Enter the **device URI**:  
   `smb://drz-moog.d.ethz.ch/drz-std4-20-hpm551`
3. Set authentication details:  
   - **Username:** `d\taydin`  
   - **Password:** `eth/nethz`
4. Use this driver:  
   <https://wiki.drz.li/drz-std4-20-hpm551.ppd>

Save and print a test page to confirm setup.

---




