#FROM    ubuntu:rolling => NOK
#FROM    ubuntu:14.04 => OK
#FROM    debian:latest => NOK
#FROM    alpine:latest => NOK
FROM    ubuntu:14.04

RUN     locale-gen en_US en_US.UTF-8

# Make sure we don't get notifications we can't answer during building.
ENV     DEBIAN_FRONTEND noninteractive

# Update the system
RUN     apt-get -q update && \
        apt-get install -qy --force-yes apt-utils
RUN     apt-get -q update && \
        #apt-mark hold initscripts udev plymouth mountall && \
        apt-get -qy --force-yes dist-upgrade

RUN     apt-get install -qy --force-yes git supervisor && \
        apt-get -yq install sudo build-essential libcrypt-ssleay-perl libnet-ssleay-perl libcompress-raw-lzma-perl libio-compress-lzma-perl wget libyaml-perl libconfig-yaml-perl fcgiwrap spawn-fcgi libfcgi-perl  libfcgi-procmanager-perl perl-modules libnet-ssleay-perl libcrypt-ssleay-perl liburi-perl libjson-perl libjavascript-minifier-xs-perl libperlio-gzip-perl libmodule-install-perl libmodule-build-perl liblocal-lib-perl libjson-pp-perl libcpan-meta-perl libdbd-sqlite3 libdbd-sqlite3-perl libcurl4-nss-dev get-flash-videos vim mariadb-server mariadb-client libdbd-mysql-perl

#Set CGIPROXY DIRS
RUN     mkdir /var/run/cgiproxy/ && \
	chmod -R 770 /var/run/cgiproxy/ && \
        chown -R www-data:www-data /var/run/cgiproxy/ && \
        mkdir /opt/cgiproxy/ && \
        chmod -R 770 /opt/cgiproxy && \
        chown -R www-data /opt/cgiproxy/ && \
        mkdir /var/www && \
        chmod -R 770 /var/www && \
        chown -R www-data /var/www


#Get CGIPROXY SOURCE
RUN     cd /opt/cgiproxy/ && wget http://www.jmarshall.com/tools/cgiproxy/releases/cgiproxy.latest.tar.gz && tar zxf cgiproxy.latest.tar.gz

#Configure CGIPROXY VARS
        RUN FIRST="RUN_AS_USER= '" && \
        SECOND="\$RUN_AS_USER= 'www-data' ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="PROXY_DIR= '" && \
        SECOND="\$PROXY_DIR= '/opt/cgiproxy/' ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="SECRET_PATH= '" && \
        SECOND="\$SECRET_PATH= 'proxy123' ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="FCGI_SOCKET= " && \
        SECOND="\$FCGI_SOCKET= '/var/run/cgiproxy/cgiproxy.fcgi.socket' ;" && \
#        SECOND="\$FCGI_SOCKET= 8002 ;" && \
       sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="USER_FACING_PORT= " && \
        SECOND="\$USER_FACING_PORT= 443 ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="RUNNING_ON_SSL_SERVER= " && \
        SECOND="\$RUNNING_ON_SSL_SERVER= 1 ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        sed -i "s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="ALLOW_RTMP_PROXY= " && \
        SECOND="\$ALLOW_RTMP_PROXY= 1 ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="DB_DRIVER= '" && \
        SECOND="\$DB_DRIVER= 'MySQL' ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="DB_SERVER= '" && \
        SECOND="\$DB_SERVER= \"localhost:3306\" ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="DB_NAME= '" && \
        SECOND="\$DB_NAME= 'cgiproxy' ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="DB_USER= '" && \
        SECOND="\$DB_USER= 'cgiproxy' ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="DB_PASS= '" && \
        SECOND="\$DB_PASS= 'cgiproxy1' ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi && \
        FIRST="USE_DB_FOR_COOKIES= " && \
        SECOND="\$USE_DB_FOR_COOKIES= 1 ;" && \
        sed -i "0,/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/s/^.*$(echo $FIRST | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g').*/$(echo $SECOND | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" /opt/cgiproxy/nph-proxy.cgi

#Create DB && init cgiproxy

RUN service mysql start && \
    mysql -u root -p mysql -e "CREATE DATABASE cgiproxy; GRANT ALL PRIVILEGES ON cgiproxy.* TO cgiproxy@localhost IDENTIFIED BY 'cgiproxy1'; FLUSH PRIVILEGES; SHOW DATABASES;" && \
    cd /opt/cgiproxy/ ; chmod +x nph-proxy.cgi ; ./nph-proxy.cgi install-modules ; ./nph-proxy.cgi init

RUN grep -E "RUN_AS_USER|PROXY_DIR|SECRET_PATH|FCGI_SOCKET|USER_FACING_PORT|RUNNING_ON_SSL_SERVER|RUNNING_ON_SSL_SERVER|ALLOW_RTMP_PROXY|LOCAL_LIB_DIR|DB_DRIVER|DB_DRIVER|DB_SERVER|DB_NAME|DB_USER|DB_PASS|USE_DB_FOR_COOKIES" /opt/cgiproxy/nph-proxy.cgi

# Clean up
RUN     apt-get clean ; rm -rf /tmp/* /var/tmp/* ; rm -rf /var/lib/apt/lists/* ; rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup ; rm /opt/cgiproxy/cgiproxy.latest.tar.gz ; exit 0


WORKDIR /opt/cgiproxy

#Start
CMD	["/bin/bash", "-c", "service mysql start; sudo -u www-data ./nph-proxy.cgi start-fcgi"]
