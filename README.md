# Docker-kerberos
I've modified the original project to simulate database server kerberos authentication.

## General
```
git clone https://github.com/gaborgsomogyi/docker-kerberos.git
cd docker-kerberos

# Docker need couple of jars
cd pgjdbc-kerberos/
mvn clean install
cd -

cd mysql-kerberos/
mvn clean install
cd -

cd mariadb-kerberos/
mvn clean install
cd -

cd db2-kerberos/
mvn clean install
cd -

cd mssql-kerberos/
mvn clean install
cd -

cd oracle-kerberos/
mvn clean install
cd -

docker-compose build
```

## KDC
```
./run-kdc-kadmin.sh
```

## Postgres
```
./run-postgres.sh
```

```
./run-kerberos-client.sh postgres
export KRB5_TRACE=/dev/stdout
kinit -kt /share/postgres.keytab postgres/example.com@EXAMPLE.COM
psql -U postgres/example.com@EXAMPLE.COM -h example.com postgres
```

```
./run-kerberos-client.sh postgres
export KRB5_TRACE=/dev/stdout
kinit -kt /share/postgres.keytab postgres/example.com@EXAMPLE.COM
java -jar /tmp/pgjdbc-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar share/postgres.keytab postgres/example.com@EXAMPLE.COM "jdbc:postgresql://example.com/postgres?user=postgres/example.com@EXAMPLE.COM&gsslib=gssapi"
```

## MySQL
```
docker login container-registry.oracle.com
./run-mysql.sh
```

```
./run-kerberos-client.sh mysql
export KRB5_TRACE=/dev/stdout
kinit -kt /share/mysql.keytab mysql/example.com@EXAMPLE.COM
// No GSSAPI plugin so failing
java -jar /tmp/mysql-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar share/mysql.keytab mysql/example.com@EXAMPLE.COM "jdbc:mysql://example.com/mysql?user=mysql/example.com@EXAMPLE.COM"
```

## MariaDB
```
./run-mariadb.sh
```

```
./run-kerberos-client.sh mariadb
export KRB5_TRACE=/dev/stdout
kinit -kt /share/mariadb.keytab mariadb/example.com@EXAMPLE.COM
java -jar /tmp/mariadb-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar share/mariadb.keytab mariadb/example.com@EXAMPLE.COM "jdbc:mariadb://example.com/mysql?user=mariadb/example.com@EXAMPLE.COM"
```

## DB2
```
./run-db2.sh
```

```
./run-kerberos-client.sh db2
export KRB5_TRACE=/dev/stdout
kinit -kt /share/db2.keytab db2/example.com@EXAMPLE.COM
java -jar /tmp/db2-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar share/db2.keytab db2/example.com@EXAMPLE.COM "jdbc:db2://example.com:50000/db2"
```

## MSSQL
```
./run-mssql.sh
```

```
./run-kerberos-client.sh mssql
sqlcmd -S example.com -U sa -P Mssql123
```

```
./run-kerberos-client.sh mssql
export KRB5_TRACE=/dev/stdout
kinit -kt /share/mssql.keytab mssql/example.com@EXAMPLE.COM
// The login is from an untrusted domain and cannot be used with Integrated authentication.
java -jar /tmp/mssql-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar share/mssql.keytab mssql/example.com@EXAMPLE.COM "jdbc:sqlserver://example.com;integratedSecurity=true;authenticationScheme=JavaKerberos;userName=mssql/example.com@EXAMPLE.COM"
```

## Oracle
```
docker login container-registry.oracle.com
./run-oracle.sh
```

```
./run-kerberos-client.sh oracle
export KRB5_TRACE=/dev/stdout
kinit -kt /share/oracle.keytab oracle/example.com@EXAMPLE.COM
// ORA-01017: invalid username/password; logon denied
sqlplus '/@(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=example.com)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=ORCLCDB.localdomain)))'
```

```
./run-kerberos-client.sh oracle
export KRB5_TRACE=/dev/stdout
kinit -kt /share/oracle.keytab oracle/example.com@EXAMPLE.COM
// ORA-01017: invalid username/password; logon denied
java -jar /tmp/oracle-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar share/oracle.keytab oracle/example.com@EXAMPLE.COM "jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=example.com)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=ORCLCDB.localdomain)))"
```
