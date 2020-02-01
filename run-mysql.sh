#!/bin/bash

current_dir=$(pwd)

share_dir=$current_dir/mysql_share
rm -rf $share_dir
mkdir -p $share_dir
cp $current_dir/share/mysql.keytab $share_dir
cp $current_dir/share/mysql_krb_setup.sh $share_dir

docker run -it -e MYSQL_ROOT_PASSWORD=mysql --mount type=bind,source=$share_dir,target=/docker-entrypoint-initdb.d docker-kerberos_mysql-server:latest
