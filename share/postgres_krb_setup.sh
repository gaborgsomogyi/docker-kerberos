#!/usr/bin/env bash

echo $(hostname -I) > /docker-entrypoint-initdb.d/database.ip
sed -i 's/host all all all trust/host all all all gss/g' /var/lib/postgresql/data/pg_hba.conf
echo "krb_server_keyfile='/docker-entrypoint-initdb.d/postgres.keytab'" >> /var/lib/postgresql/data/postgresql.conf
psql -U postgres -c "CREATE ROLE \"postgres/example.com@EXAMPLE.COM\" LOGIN SUPERUSER"
