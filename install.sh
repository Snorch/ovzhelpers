#!/bin/bash

mkdir -p ~/bin

# Use 'install -m' rather than 'cp': cp does not update the mode of a
# destination that already exists, so a stale non-executable copy would never
# get its +x bit fixed by re-running this script. install always sets the mode.
for f in vzvm vzct kinst kmake modstrip nfs-export-dir.sh build-vz7 rh-conf \
	 rpmbuild-vz9 build-in-docker build-kernel crash-remote
do
	install -m 755 "$f" ~/bin/
done

mkdir -p ~/.claude/skills/kernel-docker-build/
install -m 644 claude-kernel-docker-build-SKILL.md ~/.claude/skills/kernel-docker-build/SKILL.md
mkdir -p ~/.claude/skills/remote-crash-debugging/
install -m 644 claude-remote-crash-debugging-SKILL.md ~/.claude/skills/remote-crash-debugging/SKILL.md
