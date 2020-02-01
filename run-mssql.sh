#!/bin/bash

current_dir=$(pwd)

share_dir=$current_dir/mssql_share
rm -rf $share_dir
mkdir -p $share_dir
cp $current_dir/share/krb5.conf $share_dir
cp $current_dir/share/mssql.keytab $share_dir
cp $current_dir/share/mssql_krb_setup.sh $share_dir

docker run -u 0 -it -e ACCEPT_EULA=Y -e SA_PASSWORD="Mssql123" --mount type=bind,source=$share_dir,target=/docker-entrypoint-initdb.d mcr.microsoft.com/mssql/server:2019-CU2-ubuntu-16.04 /docker-entrypoint-initdb.d/mssql_krb_setup.sh
