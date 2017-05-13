Automated install of owncloud on Raspberry Pi.

Installation steps on a Raspberry Pi:

1. Run the command, 'git clone https://github.com/zen93/rpi-owncloud-auto.git' in your home directory
2. Change the permissions on the scripts with, 'chmod -R +x /rpi-owncloud-auto'
3. Change directory, 'cd rpi-owncloud-auto'
4. Run the scripts in order (you can run scripts as './scriptname.sh')
  a. install.sh
     A screen shows up asking to "configure locales". Please select "en_US.UTF-8 UTF-8" option.
     A certificate will be generated; enter the details it asks you.
     When it asks to enter your raspberry pi address, please enter the internal IP address of your Pi on your LAN Network.
     Reboot with 'sudo reboot'
  b. owncloud.sh
     Connect hard disk after running this script. Make sure only one HDD is connected (to be used with owncloud)
  c. harddive.sh
     Reboot to mount the disk.

All the steps have been taken from https://pimylifeup.com/raspberry-pi-owncloud/.
Use that as reference if stuck somewhere.
I have tried my best to make it easy to automate this whole process. Hope you enjoy using this tool!
