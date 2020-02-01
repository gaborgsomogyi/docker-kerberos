#!/usr/bin/env bash

echo $(hostname -I) > /docker-entrypoint-initdb.d/database.ip
cp /docker-entrypoint-initdb.d/krb5.conf /etc/
/opt/mssql/bin/sqlservr
