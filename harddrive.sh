#!/bin/bash
echo "Only connect one hard disk/usb device to the raspberry pi and ensure it is the device you intend to mount and use with owncloud.
It is assumed the drive is located at /sda1. If it is not please make the required changes in harddrive.sh"
echo "Continue? (Y/n)"
read response
if [ $response = "Y" ]; then
  sudo apt-get -y install ntfs-3g
  sudo mkdir /media/ownclouddrive
  mGID="$(id -g www-data)"
  mUID="$(id -u www-data)"
  mUUID="$(ls -l /dev/disk/by-uuid | grep sda1 | cut -d ' ' -f9 | head -n1)"
  sudo echo "UUID=${mUUID} /media/ownclouddrive auto nofail,uid=${mUID},gid=${mGID},umask=0027,dmask=0027,noatime 0 0" >> /etc/fstab
  echo "Added drive with UUID=${mUUID} to fstab. Please reboot pi to mount the drive."
else
  echo "Cancelled."
fi
