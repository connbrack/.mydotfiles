#!/bin/bash

kb="totem"
km="main"

qmk compile -kb $kb -km $km

read -p "Type 'y' to flash: " RESPONSE
[ "$RESPONSE" != "y" ] && exit 0

sudo true

echo "Waiting for device..."
while [ -z "$(blkid -L RPI-RP2 2>/dev/null)" ]; do
    sleep 0.5
done

DEVICE=$(blkid -L RPI-RP2 2>/dev/null)
MOUNTPOINT="/mnt/RPI-RP2"
sudo mkdir -p "$MOUNTPOINT"
sudo mount -o uid=$(id -u),gid=$(id -g) "$DEVICE" "$MOUNTPOINT"

qmk flash -kb $kb -km $km

sudo umount "$MOUNTPOINT"
