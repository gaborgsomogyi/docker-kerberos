#!/usr/bin/env bash

echo $(hostname -I) > /docker-entrypoint-initdb.d/database.ip
sudo cp /docker-entrypoint-initdb.d/krb5.conf /etc/
SQLNETORAFILE=/u01/app/oracle/product/12.2.0/dbhome_1/admin/ORCLCDB/sqlnet.ora
echo "SQLNET.AUTHENTICATION_SERVICES = (BEQ,KERBEROS5)" >> $SQLNETORAFILE
echo "SQLNET.AUTHENTICATION_KERBEROS5_SERVICE = oracle" >> $SQLNETORAFILE
echo "SQLNET.KERBEROS5_CONF = /docker-entrypoint-initdb.d/krb5.conf" >> $SQLNETORAFILE
echo "SQLNET.KERBEROS5_KEYTAB = /docker-entrypoint-initdb.d/oracle.keytab" >> $SQLNETORAFILE
echo "SQLNET.KERBEROS5_CONF_MIT = false" >> $SQLNETORAFILE
echo "DIAG_ADR_ENABLED = on" >> $SQLNETORAFILE
echo "TRACE_LEVEL_SERVER = 16" >> $SQLNETORAFILE
echo "TRACE_DIRECTORY_SERVER = /var/log/" >> $SQLNETORAFILE
echo "TRACE_LEVEL_CLIENT = 16" >> $SQLNETORAFILE
sqlplus / as sysdba <<EOF
alter session set "_ORACLE_SCRIPT"=true;
create user "oracle/example.com@EXAMPLE.COM" identified externally;
grant create session to "oracle/example.com@EXAMPLE.COM";
alter system set common_user_prefix='' scope=spfile;
alter system set os_authent_prefix='' scope=spfile;
shutdown immediate;
startup;
EOF
