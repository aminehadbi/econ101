#!/bin/bash

# mount arts server if needed
if grep -qs '/mnt/arts' /proc/mounts; then
    echo ""
else 
    echo "Mounting arts ftp server"
    exec "/home/paul/mountArts.sh"
fi

mkdir -p /tmp/rsync

find . -regex ".*lec[0-9][0-9].*pdf" -exec rsync -tvhc  --progress --temp-dir=/tmp/rsync  {} /mnt/arts/526 \;
#find problemSets -iname "526*.pdf" -not -iname "*sol*pdf" -exec rsync -tvhc  --progress  --temp-dir=/tmp/rsync {} /mnt/arts/526 \;
find . -iname "*.html" -exec rsync -tvhc --progress --temp-dir=/tmp/rsync {} /mnt/arts/526 \;
find . -iname "526-syllabus.pdf" -exec rsync -tvhc  --progress --temp-dir=/tmp/rsync  {} /mnt/arts/526 \;


