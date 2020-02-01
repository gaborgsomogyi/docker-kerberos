#!/bin/bash

current_dir=$(pwd)
docker run -it --env-file=kerberos.env --mount type=bind,source=$current_dir/share,target=/share -p 88:88 -p 749:749 docker-kerberos_kdc-kadmin:latest
