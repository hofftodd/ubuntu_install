#!/bin/bash
set -euo pipefail

# Tools for browsing and mounting NAS shares over SMB and NFS.
#   smbclient    — list/test SMB shares
#   cifs-utils   — provides mount.cifs for /etc/fstab CIFS mounts
#   nfs-common   — provides showmount and mount.nfs for /etc/fstab NFS mounts
sudo apt-get update
sudo apt-get install -y smbclient cifs-utils nfs-common

echo "NAS tools installed."
echo "  Browse SMB shares:  smbclient -L //<host> -N    (or -U <user>)"
echo "  List NFS exports:   showmount -e <host>"
