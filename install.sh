#!/bin/bash
echo "Updating and upgrading packages..."
sudo apt-get update && sudo apt-get -y upgrade
echo "Configuring locales..."
sudo dpkg-reconfigure locales
echo "You can revert locale using raspi-config."
echo "Changing Memory split to 240/16..."
sudo cp /boot/arm240_start.elf /boot/start.elf
echo "Add www-data to www-data group..."
sudo usermod -a -G www-data www-data
echo "Installing packages..."
sudo apt-get --yes --force-yes install nginx openssl ssl-cert php5-cli php5-sqlite php5-gd php5-common php5-cgi sqlite3 php-pear php-apc curl libapr1 libtool curl libcurl4-openssl-dev php-xml-parser php5 php5-dev php5-curl php5-gd php5-fpm memcached php5-memcache varnish
echo "Creating ssl certificate..."
sudo openssl req $@ -new -x509 -days 730 -nodes -out /etc/nginx/cert.pem -keyout /etc/nginx/cert.key
sudo chmod 600 /etc/nginx/cert.pem
sudo chmod 600 /etc/nginx/cert.key

echo "Generating and replacing nginx default file..."
sudo sh -c "echo '' > /etc/nginx/sites-available/default"

while true; do
  echo "Enter your Raspberry Pi's IP address"
  read ipadd
  echo "You have entered $ipadd. Please confirm this is correct? (y/N)"
  read response
  if [ $response = "y" ]; then
    echo "Setting ip as $ipadd."
    break
  else
    echo "Re-enter the correct ip-address. Ctrl-C to exit this loop."
  fi
done

SERVERCONFIG="upstream php-handler {
    server 127.0.0.1:9000;
    #server unix:/var/run/php5-fpm.sock;
}
server {
    listen 80;
    server_name $ipadd;
    return 301 https://\$server_name\$request_uri;  # enforce https
}

server {
    listen 443 ssl;
    server_name $ipadd;
    ssl_certificate /etc/nginx/cert.pem;
    ssl_certificate_key /etc/nginx/cert.key;
    # Path to the root of your installation
    root /var/www/owncloud;
    client_max_body_size 1000M; # set max upload size
    fastcgi_buffers 64 4K;
    rewrite ^/caldav(.*)$ /remote.php/caldav\$1 redirect;
    rewrite ^/carddav(.*)$ /remote.php/carddav\$1 redirect;
    rewrite ^/webdav(.*)$ /remote.php/webdav\$1 redirect;
    index index.php;
    error_page 403 /core/templates/403.php;
    error_page 404 /core/templates/404.php;
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
    location ~ ^/(?:\.htaccess|data|config|db_structure\.xml|README) {
        deny all;
    }
    location / {
        # The following 2 rules are only needed with webfinger
        rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
        rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;
        rewrite ^/.well-known/carddav /remote.php/carddav/ redirect;
        rewrite ^/.well-known/caldav /remote.php/caldav/ redirect;
        rewrite ^(/core/doc/[^\/]+/)$ \$1/index.html;
        try_files \$uri \$uri/ index.php;
    }
    location ~ \.php(?:$|/) {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_param HTTPS on;
        fastcgi_pass php-handler;
   }
   # Optional: set long EXPIRES header on static assets
   location ~* \.(?:jpg|jpeg|gif|bmp|ico|png|css|js|swf)$ {
        expires 30d;
        # Optional: Don't log access to assets
        access_log off;
   }
}"

sudo sh -c "echo \"$SERVERCONFIG\" > /etc/nginx/sites-available/default"

echo "Configuring PHP and other stuff..."
sudo sed -i 's/^upload_max_filesize.*$/upload_max_filesize = 2000M/' /etc/php5/fpm/php.ini
sudo sed -i 's/^post_max_size.*$/post_max_size = 2000M/' /etc/php5/fpm/php.ini
sudo sed -i 's/^listen.*$/listen = 127.0.0.1:9000/' /etc/php5/fpm/pool.d/www.conf
sudo sed -i 's/^CONF_SWAPSIZE.*$/CONF_SWAPSIZE = 512/' /etc/dphys-swapfile
echo "Done."

echo "Please reboot your raspberry pi and run the owncloud installation script, owncloud.sh. Use 'sudo reboot'"
