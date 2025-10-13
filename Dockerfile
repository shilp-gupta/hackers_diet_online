FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_PID_FILE=/var/run/apache2/apache2.pid \
    APACHE_LOCK_DIR=/var/run/apache2 \
    APACHE_RUN_DIR=/var/run/apache2 \
    PERL5LIB=/server/bin/httpd/cgi-bin:/server/bin/httpd/cgi-bin/HDiet/Cgi

RUN apt-get update && apt-get install -y --no-install-recommends \
        apache2 \
        libapache2-mod-perl2 \
        dnsutils \
        libcgi-pm-perl \
        libgd-perl \
        libxml-libxml-perl \
        libcrypt-cbc-perl \
        build-essential \
        cpanminus \
        libssl-dev \
        perl \
    && cpanm --notest \
        Crypt::OpenSSL::AES \
        Digest::SHA1 \
    && apt-get purge -y --auto-remove build-essential libssl-dev \
    && rm -rf /var/lib/apt/lists/* /root/.cpanm

WORKDIR /opt/hackers_diet_online
COPY . /opt/hackers_diet_online

RUN mkdir -p /server/bin/httpd/cgi-bin \
        /server/pub/hackdiet/Users \
        /server/pub/hackdiet/Sessions \
        /server/pub/hackdiet/RememberMe \
        /server/pub/hackdiet/ClusterSync \
        /server/run/ClusterSync \
        /server/log/hackdiet \
    && cp -r src/HDiet /server/bin/httpd/cgi-bin/ \
    && cp src/HackDiet.pl src/HackDietBadge.pl src/jig.pl src/wz_jsgraphics.js /server/bin/httpd/cgi-bin/ \
    && ln -sf HackDiet.pl /server/bin/httpd/cgi-bin/HackDiet \
    && ln -sf HackDietBadge.pl /server/bin/httpd/cgi-bin/HackDietBadge \
    && mkdir -p /var/www/html/hackdiet \
    && mkdir -p /var/www/html/hackdiet/online \
    && rm -rf /var/www/html/hackdiet/online/* \
    && cp -r /opt/hackers_diet_online/webdoc/. /var/www/html/hackdiet/online/ \
    && chmod +x /server/bin/httpd/cgi-bin/*.pl /opt/hackers_diet_online/docker/entrypoint.sh \
    && chown -R www-data:www-data /server/pub/hackdiet

RUN rm -f /etc/apache2/sites-enabled/* \
    && cp /opt/hackers_diet_online/docker/apache/hackersdiet.conf /etc/apache2/sites-available/hackersdiet.conf \
    && a2enmod cgid \
    && a2ensite hackersdiet

VOLUME ["/server/pub/hackdiet"]

EXPOSE 80

ENTRYPOINT ["/opt/hackers_diet_online/docker/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
