#!/bin/bash

# Exports directory as readonly nfs share

if [ "$#" -ne 2 ]; then
	echo "usage: $0 <path/to/nfs/dir> <ip/mask>"
	exit 1
fi
NFS_DIR=$1
ALLOWED_IPS=$2

# Nfs utils are probably missing
yum install nfs-utils

cat << EOF >> /etc/exports
$NFS_DIR $ALLOWED_IPS(ro,no_root_squash,no_subtree_check,async)
EOF

systemctl restart nfs-server

firewall-cmd --add-port=2049/udp
firewall-cmd --add-port=2049/tcp
firewall-cmd --add-port=111/udp
firewall-cmd --add-port=111/tcp
