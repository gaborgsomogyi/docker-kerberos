#!/bin/bash

current_dir=$(pwd)
db=$1

share_dir=${current_dir}/share
db_share_dir=${current_dir}/${db}_share

db_ip_file=${db_share_dir}/database.ip
if [ ! -f $db_ip_file ]; then
  echo "Database IP address file not found: $db_ip_file"
  exit 1
fi
cp $db_ip_file $share_dir

docker run -it --env-file=kerberos.env --mount type=bind,source=$share_dir,target=/share docker-kerberos_kerberos-client:latest
