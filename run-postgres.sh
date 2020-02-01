#!/bin/bash

current_dir=$(pwd)

share_dir=$current_dir/postgres_share
rm -rf $share_dir
mkdir -p $share_dir
cp $current_dir/share/postgres.keytab $share_dir
cp $current_dir/share/postgres_krb_setup.sh $share_dir

docker run -it --mount type=bind,source=$share_dir,target=/docker-entrypoint-initdb.d -p 5432:5432 postgres:12.0
