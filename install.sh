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

echo "export PATH=\"$HOME/bin:$PATH\"" > ~/.bashrc
