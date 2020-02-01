#!/usr/bin/env bash

echo $(hostname -I) > /var/custom/database.ip

USERPROFILE=/database/config/db2inst1/sqllib/userprofile
echo "export DB2_KRB5_PRINCIPAL=db2/example.com@EXAMPLE.COM" >> $USERPROFILE
echo "export KRB5_KTNAME=/var/custom/db2.keytab" >> $USERPROFILE
su - db2inst1 -c "db2set DB2ENVLIST=KRB5_KTNAME"

su - db2inst1 -c "db2 UPDATE DBM CFG USING SRVCON_GSSPLUGIN_LIST IBMkrb5 IMMEDIATE"
su - db2inst1 -c "db2 UPDATE DBM CFG USING SRVCON_AUTH KERBEROS IMMEDIATE"

su - db2inst1 -c "db2stop force; db2start"
