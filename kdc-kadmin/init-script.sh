#!/bin/bash
echo "==================================================================================="
echo "==== Kerberos KDC and Kadmin ======================================================"
echo "==================================================================================="
KADMIN_PRINCIPAL_FULL=$KADMIN_PRINCIPAL@$REALM

echo "REALM: $REALM"
echo "KADMIN_PRINCIPAL_FULL: $KADMIN_PRINCIPAL_FULL"
echo "KADMIN_PASSWORD: $KADMIN_PASSWORD"
echo ""

echo "==================================================================================="
echo "==== /etc/krb5.conf ==============================================================="
echo "==================================================================================="
KDC_KADMIN_SERVER=$(hostname -I)
tee /etc/krb5.conf <<EOF
[libdefaults]
	default_realm = $REALM
	forwardable = true

[realms]
	$REALM = {
		kdc_ports = 88
		kadmind_port = 749
		kdc = $KDC_KADMIN_SERVER
		admin_server = $KDC_KADMIN_SERVER
	}
EOF
cp /etc/krb5.conf /share
echo ""

echo "==================================================================================="
echo "==== /etc/krb5kdc/kdc.conf ========================================================"
echo "==================================================================================="
tee /etc/krb5kdc/kdc.conf <<EOF
[realms]
  $REALM = {
    acl_file = /etc/krb5kdc/kadm5.acl
    max_renewable_life = 7d 0h 0m 0s
    supported_enctypes = $SUPPORTED_ENCRYPTION_TYPES
    default_principal_flags = +preauth
  }
[logging]
  debug = true
  kdc = CONSOLE
  kdc = FILE:/var/log/kdc.log
  admin_server = CONSOLE
  admin_server = FILE:/var/log/kadmin.log
EOF
echo ""

echo "==================================================================================="
echo "==== /etc/krb5kdc/kadm5.acl ======================================================="
echo "==================================================================================="
tee /etc/krb5kdc/kadm5.acl <<EOF
$KADMIN_PRINCIPAL_FULL *
noPermissions@$REALM X
EOF
echo ""

echo "==================================================================================="
echo "==== Creating realm ==============================================================="
echo "==================================================================================="
MASTER_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
# This command also starts the krb5-kdc and krb5-admin-server services
krb5_newrealm <<EOF
$MASTER_PASSWORD
$MASTER_PASSWORD
EOF
echo ""

echo "==================================================================================="
echo "==== Create the principals in the acl ============================================="
echo "==================================================================================="
echo "Adding $KADMIN_PRINCIPAL principal"
kadmin.local -q "delete_principal -force $KADMIN_PRINCIPAL_FULL"
echo ""
kadmin.local -q "addprinc -pw $KADMIN_PASSWORD $KADMIN_PRINCIPAL_FULL"
echo ""

echo "Adding noPermissions principal"
kadmin.local -q "delete_principal -force noPermissions@$REALM"
echo ""
kadmin.local -q "addprinc -pw $KADMIN_PASSWORD noPermissions@$REALM"
echo ""

add_principal () {
  CUSTOM_PRINCIPAL=$1
  CUSTOM_KEYTAB=$2
  echo "Adding $CUSTOM_PRINCIPAL principal"
  kadmin.local -q "delete_principal -force $CUSTOM_PRINCIPAL@$REALM"
  echo ""
  kadmin.local -q "addprinc -pw $KADMIN_PASSWORD $CUSTOM_PRINCIPAL@$REALM"
  echo ""
  if [[ -n $CUSTOM_KEYTAB ]]; then
    CUSTOM_KEYTAB_PATH=/share/$CUSTOM_KEYTAB
    rm -f $CUSTOM_KEYTAB_PATH
    kadmin.local -q "xst -k $CUSTOM_KEYTAB_PATH $CUSTOM_PRINCIPAL@$REALM"
    chmod 666 $CUSTOM_KEYTAB_PATH
    echo ""
  fi
}
add_principal postgres/example.com postgres.keytab
add_principal mysql/example.com mysql.keytab
add_principal mariadb/example.com mariadb.keytab
add_principal db2/example.com db2.keytab
add_principal MSSQLSvc/example.com:1433
add_principal mssql/example.com mssql.keytab
add_principal oracle/example.com oracle.keytab

while true; do sleep infinity; done
