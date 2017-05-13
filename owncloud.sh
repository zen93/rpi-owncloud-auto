#!/bin/bash
echo "Installing owncloud..."
sudo mkdir -p /var/www/owncloud
sudo wget https://download.owncloud.org/community/owncloud-9.1.0.tar.bz2
sudo tar xvf owncloud-9.1.0.tar.bz2
sudo mv owncloud/ /var/www/
sudo chown -R www-data:www-data /var/www
rm -rf owncloud owncloud-9.1.0.tar.bz2
echo "Done."
echo "Configuring owncloud..."
sudo sed -i 's/^php_value_upload_max_filesize.*$/php_value_upload_max_filesize = 2000M/' /var/www/owncloud/.htaccess
sudo sed -i 's/^php_value_post_max_size.*$/php_value_post_max_size = 2000M/' /var/www/owncloud/.htaccess
sudo sed -i 's/^php_value_memory_limit.*$/php_value_memory_limit = 2000M/' /var/www/owncloud/.htaccess

sudo sed -i 's/^upload_max_filesize.*$/upload_max_filesize=2000M/' /var/www/owncloud/.user.ini
sudo sed -i 's/^post_max_size.*$/post_max_size=2000M/' /var/www/owncloud/.user.ini
sudo sed -i 's/^memory_limit.*$/memory_limit=2000M/' /var/www/owncloud/.user.ini
echo "Done."

echo "Please connect the external harddisk to your raspberry pi and run the hard drive configuration script, harddrive.sh.
Only connect one hard disk/usb device to the raspberry pi and ensure it is the device you intend to mount and use with owncloud.
It is assumed the drive is located at /sda1. If it is not please make the required changes in harddrive.sh"
