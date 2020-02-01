#!/usr/bin/env bash

echo $(hostname -I) > /docker-entrypoint-initdb.d/database.ip
mysql -u root -p'mysql' mysql -e 'CREATE USER "mariadb/example.com@EXAMPLE.COM" IDENTIFIED WITH gssapi;'
mysql -u root -p'mysql' mysql -e 'GRANT ALL PRIVILEGES ON * TO "mariadb/example.com@EXAMPLE.COM";'
