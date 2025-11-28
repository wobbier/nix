```text
██████╗  █████╗ ███╗   ██╗██╗  ██╗████████╗ █████╗ ███╗   ██╗██╗  ██╗
██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝╚══██╔══╝██╔══██╗████╗  ██║██║ ██╔╝
██   ██║███████║██╔██╗ ██║█████╔╝    ██║   ███████║██╔██╗ ██║█████╔╝ 
██╔══██║██╔══██║██║╚██╗██║██╔═██╗    ██║   ██╔══██║██║╚██╗██║██╔═██╗ 
██████╔╝██║  ██║██║ ╚████║██║  ██╗   ██║   ██║  ██║██║ ╚████║██║  ██╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
```

# 🧊 NixOS Fresh Install 😎

This guide explains how to restore your entire NixOS setup after a fresh install — fast, clean, and reproducibly.

It covers:

- 🔐 1Password SSH agent  
- 🔑 GitHub SSH access  
- 📁 Cloning your Nix config repo  
- 🔗 Linking `/etc/nixos` → `~/nix`  
- 🖥️ Generating hardware config  
- 🛠️ Rebuilding system  
- 🏠 Home Manager auto-integration  
- 🧹 Chrome profile lock fix  
- 🔧 SSH host key fixes

---

## 🥷 1) Enable 1Password & SSH Agent

Install 1Password GUI + CLI (one-time during bootstrap):

```bash
nix-shell -p _1password _1password-gui
```

Open 1Password → **Settings → Developer**  
Enable:

✔ Use the 1Password SSH Agent

Check the agent:

```bash
echo $SSH_AUTH_SOCK
```

Check GitHub SSH key is recognized:

```bash
ssh-add -l
```

If not signed in:

```bash
eval $(op signin)
```

---

## 📥 2) Clone Your NixOS Config Repo

```bash
cd ~
git clone git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git nix
```

Verify GitHub SSH:

```bash
ssh -T git@github.com
```

---

## 🔗 3) Link Repo to `/etc/nixos`

Remove default system config:

```bash
sudo rm -rf /etc/nixos
```

Symlink your repo:

```bash
sudo ln -s ~/nix /etc/nixos
```

Verify:

```bash
ls -l /etc/nixos
```

---

## ⚙️ 4) Generate Hardware Configuration

```bash
sudo nixos-generate-config
```

This generates your machine-specific:

```
~/nix/hardware-configuration.nix
```

⚠️ This file is gitignored — each machine keeps its own version.

---

## 🛠️ 5) Rebuild the System

```bash
cd ~/nix
sudo nixos-rebuild switch
```

This applies:

- 🖥️ Host config  
- 📦 Shared modules  
- 👤 users/mitch.nix  
- 🏠 Home Manager (auto via fetchTarball)  
- 🔧 All system + home packages  

---

## 🧼 6) (Optional) Chrome Profile Lock Fix

If Chrome refuses to start or says:

> "The profile appears to be in use by another computer (nixos)"

Fix:

```bash
rm ~/.config/google-chrome/Singleton*
```

Relaunch Chrome.

---

## 🔧 7) (Optional) Reset SSH Host Keys

If SSH server breaks or complains:

```bash
sudo rm /etc/ssh/ssh_host_*
sudo systemctl restart sshd
```

---

## 🎉 8) Done!

Your system is now fully restored:

- 🧊 NixOS system config  
- 🏠 Home Manager environment  
- 🖥️ Desktop environment  
- 📦 System + user packages  
- 🔐 1Password SSH agent  
- 🔑 GitHub SSH working  
- 💻 Hardware config loaded  
- 🧑‍💻 Hostname + modules  
- 🔗 Repo-linked configuration  

Your machine is officially **DankTank™ Certified** 💪🔥
