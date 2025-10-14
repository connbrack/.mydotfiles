#!/bin/bash


kb="totem"
km="connor"

qmkhome="$(qmk config | sed -n '/home/s/.*=\(.*\)/\1/p')"
fname=$(qmk compile -kb $kb -km $km -n 2>&1 | tr ' ' '\n' | sed -n '/TARGET/s/TARGET=//p').uf2

qmk compile -kb $kb -km $km

read -p "Type 'y' to flash: " RESPONSE
if [ "$RESPONSE" != "y" ]; then
    echo "Exiting."
    exit 0
fi

sudo true

echo "Waiting for device..."
while [ -z "$(blkid -L RPI-RP2 2>/dev/null)" ]; do
    sleep 0.5
done

MOUNTPOINT="/mnt/RPI-RP2"
DEVICE=$(blkid -L RPI-RP2 2>/dev/null)

sudo mkdir -p "$MOUNTPOINT"

if mount | grep -q "$MOUNTPOINT"; then
    echo "Already mounted at $MOUNTPOINT"
fi

sudo mount "$DEVICE" "$MOUNTPOINT"
if [ $? -eq 0 ]; then
    echo "Mounted $DEVICE at $MOUNTPOINT"
    ls "$MOUNTPOINT"
else
    echo "Failed to mount $DEVICE"
    exit 1
fi

sudo cp $qmkhome/$fname $MOUNTPOINT

if mount | grep -q "$MOUNTPOINT"; then
    sudo umount "$MOUNTPOINT"
    echo "Unmounted $MOUNTPOINT"
fi
