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

## 2. Install Ubuntu

Proceed with a standard Ubuntu installation.
When prompted for partitioning:
- Choose **“Something else”**.
- Assign the partitions as created above:
  - `/` → ext4, mounted at `/`
  - `/home` → ext4, mounted at `/home`
- Continue installation normally.

## 3. Install Dropbox

Follow the official instructions: <https://www.dropbox.com/install-linux>

```bash
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
```

After starting Dropbox, sign in and wait for the `~/Dropbox` folder to sync your `.dotfiles` directory.
