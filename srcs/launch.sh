service mysql start
service php7.3-fpm start
service php7.3-fpm status
service nginx start

echo "CREATE USER 'adm'@'localhost' IDENTIFIED BY 'adm';" | mysql -u root
echo "create database wordpress;" | mysql -u root
echo "grant all privileges on wordpress.* to 'adm'@'localhost' identified by     'adm';" | mysql -u root
echo "flush privileges;" | mysql -u root

bash
