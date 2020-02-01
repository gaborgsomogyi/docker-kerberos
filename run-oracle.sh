#!/bin/bash

current_dir=$(pwd)

share_dir=$current_dir/oracle_share
rm -rf $share_dir
mkdir -p $share_dir
cp $current_dir/share/krb5.conf $share_dir
cp $current_dir/share/oracle.keytab $share_dir
cp $current_dir/share/oracle_krb_setup.sh $share_dir

docker run -it -h example.com --mount type=bind,source=$share_dir,target=/docker-entrypoint-initdb.d docker-kerberos_oracle-server:latest
