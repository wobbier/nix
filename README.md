============================================================
NIX
============================================================
This file contains all steps required after installing NixOS
to restore your full setup including:
- 1Password SSH agent
- GitHub SSH access
- Cloning your NixOS config repo
- Linking /etc/nixos → ~/nix
- Generating hardware config
- Rebuilding system (with Home Manager auto-integration)
============================================================


------------------------------------------------------------
1) ENABLE 1PASSWORD AND SSH AGENT
------------------------------------------------------------

# Install 1Password GUI + CLI for initial setup (temporary)
nix-shell -p _1password _1password-gui

# Start 1Password (GUI or CLI)
# Ensure “Developer → Use the 1Password SSH Agent” is enabled.

# Verify SSH_AUTH_SOCK exists:
echo $SSH_AUTH_SOCK

# Verify GitHub SSH key is available through 1Password:
ssh-add -l
# You should see your key (ED25519)

# If not signed in yet:
eval $(op signin)


------------------------------------------------------------
2) CLONE YOUR NIXOS CONFIG REPO
------------------------------------------------------------

cd ~
git clone git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git nix

# Test GitHub SSH access if needed:
ssh -T git@github.com


------------------------------------------------------------
3) LINK THE REPO TO /etc/nixos
------------------------------------------------------------

# Remove default config:
sudo rm -rf /etc/nixos

# Symlink your repo:
sudo ln -s ~/nix /etc/nixos

# Confirm:
ls -l /etc/nixos


------------------------------------------------------------
4) GENERATE HARDWARE CONFIG
------------------------------------------------------------

# This generates machine-specific hardware-configuration.nix
# It will appear inside ~/nix because of the symlink.
/etc/nixos -> ~/nix

sudo nixos-generate-config

# IMPORTANT:
# hardware-configuration.nix is intentionally gitignored.
# Each machine keeps its own version.


------------------------------------------------------------
5) REBUILD THE SYSTEM
------------------------------------------------------------

cd ~/nix
sudo nixos-rebuild switch

# This applies:
# - host-specific config
# - common modules
# - users/mitch.nix
# - Home Manager activation (via fetchTarball)
# - all system + home packages


------------------------------------------------------------
6) (OPTIONAL) CHROME PROFILE LOCK FIX
------------------------------------------------------------

# If Chrome refuses to start after hostname changes
# Example error:
# "The profile appears to be in use by another computer (nixos)"

rm ~/.config/google-chrome/Singleton*

# Relaunch Chrome normally.


------------------------------------------------------------
7) (OPTIONAL) RESET SSH HOST KEYS
------------------------------------------------------------

# Only needed if the SSH server breaks.
/etc/ssh/ssh_host_* might need removal for regenerated keys.

sudo rm /etc/ssh/ssh_host_*
sudo systemctl restart sshd


------------------------------------------------------------
8) DONE!
------------------------------------------------------------

Your system should now be fully restored with:
- NixOS system config
- Home Manager user config
- Desktop environment
- Packages + settings
- 1Password SSH agent
- GitHub access
- Hardware config
- Hostname
- Full repo-linked configuration

============================================================
END OF FILE
============================================================
