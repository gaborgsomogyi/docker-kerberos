FROM mariadb:10.4

ENV DEBIAN_FRONTEND noninteractive
# The -qq implies --yes
RUN dpkg-divert --add /bin/systemctl && ln -sT /bin/true /bin/systemctl
RUN apt-get -qq update
RUN apt-get -qq install sudo nano net-tools hostname mariadb-plugin-gssapi-server=1:10.4.12+maria~bionic
RUN apt-get -qq clean

RUN echo "gssapi_keytab_path=/docker-entrypoint-initdb.d/mariadb.keytab" >> /etc/mysql/mariadb.conf.d/auth_gssapi.cnf
RUN echo "gssapi_principal_name=mariadb/example.com@EXAMPLE.COM" >> /etc/mysql/mariadb.conf.d/auth_gssapi.cnf
