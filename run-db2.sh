#!/bin/bash

current_dir=$(pwd)

share_dir=$current_dir/db2_share
rm -rf $share_dir
mkdir -p $share_dir
cp $current_dir/share/db2.keytab $share_dir
cp $current_dir/share/db2_krb_setup.sh $share_dir

docker run -it --privileged -e DB2INST1_PASSWORD=db2 -e LICENSE=accept -e DBNAME=db2 --mount type=bind,source=$share_dir,target=/var/custom ibmcom/db2:11.5.0.0a
