#!/usr/bin/env bash

echo $(hostname -I) > /docker-entrypoint-initdb.d/database.ip
mysql -p'mysql' mysql -e 'CREATE USER "mysql/example.com@EXAMPLE.COM" IDENTIFIED WITH authentication_pam AS "mysqld";'
