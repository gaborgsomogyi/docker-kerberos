FROM debian:buster
MAINTAINER Simão Martins "simao.martins@tecnico.ulisboa.pt"

ENV DEBIAN_FRONTEND noninteractive
# The -qq implies --yes
RUN apt-get -qq update
RUN apt-get -qq install telnet nmap nano curl gnupg2 net-tools apt-transport-https locales tcpdump openjdk-11-jre krb5-user postgresql-client
RUN apt-get -qq clean

RUN locale-gen "en_US.UTF-8"
RUN echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale

# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get -qq update

# install SQL Server drivers and tools
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# install Oracle Server drivers and tools
RUN curl -O https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm
RUN curl -O https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-devel-19.3.0.0.0-1.x86_64.rpm
RUN curl -O https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-sqlplus-19.3.0.0.0-1.x86_64.rpm
RUN apt-get install -qq alien libaio1
RUN alien -i oracle-instantclient*-basic-*.rpm
RUN alien -i oracle-instantclient*-devel-*.rpm
RUN alien -i oracle-instantclient*-sqlplus-*.rpm
RUN ldconfig

ENV REALM ${REALM:-EXAMPLE.COM}
ENV KADMIN_PRINCIPAL ${KADMIN_PRINCIPAL:-kadmin/admin}
ENV KADMIN_PASSWORD ${KADMIN_PASSWORD:-MITiys4K5}

COPY pgjdbc-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar /tmp/
COPY mysql-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar /tmp/
COPY mariadb-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar /tmp/
COPY db2-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar /tmp/
COPY mssql-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar /tmp/
COPY oracle-kerberos-1.0-SNAPSHOT-jar-with-dependencies.jar /tmp/
COPY init-script.sh configureKerberosClient.sh /tmp/
CMD /tmp/init-script.sh
