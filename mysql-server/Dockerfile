FROM store/oracle/mysql-enterprise-server:8.0

RUN yum update -y
RUN yum install -y sudo nano net-tools hostname
RUN yum clean all

COPY mysqld /etc/pam.d
RUN echo "plugin-load-add=authentication_pam.so" >> /etc/my.cnf
