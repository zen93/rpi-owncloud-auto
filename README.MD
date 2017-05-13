Automated install of owncloud on Raspberry Pi.

Installation steps on a Raspberry Pi:

1. Run the command, 'git clone https://github.com/zen93/rpi-owncloud-auto.git' in your home directory
2. Change the permissions on the scripts with, 'chmod -R +x /rpi-owncloud-auto'
3. Change directory, 'cd rpi-owncloud-auto'
4. Run the scripts in order
  a. install.sh
     Reboot with 'sudo reboot'
  b. owncloud.sh
     Connect hard disk after running this script. Make sure only one HDD is connected (to be used with owncloud)
  c. harddive.sh
     Reboot to mount the disk.
