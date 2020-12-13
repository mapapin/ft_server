# --> set up
echo "\n[+] \033[0;32mWEBSITE SETUP"
echo "\033[0m"
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*
mkdir /var/www/wpsite

# --> Configuration of SSL certifificate
echo "\n[+] \033[0;32mSSL CERTIFICATION"
echo "\033[0m"
apt-get -y install openssl
apt-get install -y procps && apt-get install nano
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -days 365 -nodes -out /etc/nginx/ssl/wpsite.pem -keyout /etc/nginx/ssl/wpsite.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=mapapin/CN=wpsite"

# --> Configuration of Nginx
echo "\n[+] \033[0;32mNGINX CONFIGURATION"
echo "\033[0m"
mv ./tmp/nginx-conf /etc/nginx/sites-available/wpsite
ln -s /etc/nginx/sites-available/wpsite /etc/nginx/sites-enabled/wpsite
rm -rf /etc/nginx/sites-enabled/default

# --> Configuration of Mysql
echo "\n[+] \033[0;32mMYSQL CONFIGURATION"
echo "\033[0m"
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# --> Download Phpmyadmin
echo "\n[+] \033[0;32mPHPMYADMIN CONFIGURATION"
echo "\033[0m"
mkdir /var/www/wpsite/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.4-all-languages.tar.gz --strip-components 1 -C /var/www/wpsite/phpmyadmin
mv ./tmp/phpmyadmin.inc.php /var/www/wpsite/phpmyadmin/config.inc.php

# --> Download Wordpress files
echo "\n[+] \033[0;32mWORDPRESS CONFIGURATION"
echo "\033[0m"
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/wpsite
mv /tmp/wp-config.php /var/www/wpsite/wordpress

# --> Start services
echo "\n[+] \033[0;32mSERVICE LAUNCH"
echo "\033[0m"
service php7.3-fpm start
service nginx start
bash
#tail -f /var/log/nginx/access.log
