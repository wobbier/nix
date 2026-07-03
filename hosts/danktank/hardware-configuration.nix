# PLACEHOLDER — replace with danktank's real hardware config.
# On danktank, run from the repo root:
#   sudo nixos-generate-config --show-hardware-config > hosts/danktank/hardware-configuration.nix
# (unmount the /mnt/windows drives first so they don't get snapshotted in —
#  those mounts are declared in danktank.nix on purpose)
# Then delete the old untracked hardware-configuration.nix at the repo root,
# git add this file, and rebuild.
throw "hosts/danktank/hardware-configuration.nix is a placeholder — copy danktank's real hardware config here (see comments in this file)"
