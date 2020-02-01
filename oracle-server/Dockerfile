FROM store/oracle/database-enterprise:12.2.0.1

USER root
RUN yum update -y
RUN yum install -y sudo nano net-tools krb5-user
RUN yum clean all
RUN echo 'oracle ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN sed -i 's/# start listener/\/docker-entrypoint-initdb.d\/oracle_krb_setup.sh/g' /home/oracle/setup/configDBora.sh

USER oracle
