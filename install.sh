#!/bin/bash

if [ ! -d ~/bin ]
then
	mkdir ~/bin
fi

cp vzvm ~/bin
cp vzct ~/bin
cp kinst ~/bin
cp kmake ~/bin
cp modstrip ~/bin
cp nfs-export-dir.sh ~/bin
cp build-vz7 ~/bin
cp rh-conf ~/bin
cp rpmbuild-vz9 ~/bin
cp build-in-docker ~/bin
cp build-kernel ~/bin

mkdir -p ~/.claude/skills/kernel-docker-build/
cp claude-kernel-docker-build-SKILL.md ~/.claude/skills/kernel-docker-build/SKILL.md
