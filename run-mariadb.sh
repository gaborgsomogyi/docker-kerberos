#!/bin/bash

current_dir=$(pwd)

share_dir=$current_dir/mariadb_share
rm -rf $share_dir
mkdir -p $share_dir
cp $current_dir/share/mariadb.keytab $share_dir
cp $current_dir/share/mariadb_krb_setup.sh $share_dir

docker run -it -e MYSQL_ROOT_PASSWORD=mysql --mount type=bind,source=$share_dir,target=/docker-entrypoint-initdb.d -p 3306:3306 docker-kerberos_mariadb-server:latest
