#/bin/bash
echo "NODENAME VE MEMBYTES SWAPBYTES CGMEMBYTES CGMEMMAXBYTES CGMEMSWBYTES CGMEMSWMAXBYTES"
NODENAME=$(hostname)
for VE in $(vzlist -H -oveid); do
	PHYSPAGES=$(sed -n 's/^PHYSPAGES=.*[^0-9]\([0-9]*\)"$/\1/p' "/etc/vz/conf/$VE.conf")
	PHYSPAGES="${PHYSPAGES:-0}"
	MEMBYTES=$((PHYSPAGES * 4096))
	SWAPPAGES=$(sed -n 's/^SWAPPAGES=.*[^0-9]\([0-9]*\)"$/\1/p' "/etc/vz/conf/$VE.conf")
	SWAPPAGES="${SWAPPAGES:-0}"
	SWAPBYTES=$((SWAPPAGES * 4096))

	CGMEMBYTES=$(cat "/sys/fs/cgroup/memory/machine.slice/$VE/memory.usage_in_bytes")
	CGMEMMAXBYTES=$(cat "/sys/fs/cgroup/memory/machine.slice/$VE/memory.max_usage_in_bytes")
	CGMEMSWBYTES=$(cat "/sys/fs/cgroup/memory/machine.slice/$VE/memory.memsw.usage_in_bytes")
	CGMEMSWMAXBYTES=$(cat "/sys/fs/cgroup/memory/machine.slice/$VE/memory.memsw.max_usage_in_bytes")

	echo "$NODENAME $VE $MEMBYTES $SWAPBYTES $CGMEMBYTES $CGMEMMAXBYTES $CGMEMSWBYTES $CGMEMSWMAXBYTES"
done
