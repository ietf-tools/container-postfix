FROM docker.io/tozd/dinit:alpine-322

EXPOSE 25/tcp 465/tcp 587/tcp

VOLUME /var/log/postfix
VOLUME /var/spool/postfix
VOLUME /etc/sasl2

ENV MAILNAME=mail.example.com
ENV MY_NETWORKS="172.17.0.0/16 127.0.0.0/8"
ENV MY_DESTINATION="localhost.localdomain, localhost"
ENV ROOT_ALIAS="admin@example.com"
ENV LOG_TO_STDOUT=0

COPY ./libs /tmp/libs

RUN apk add --no-cache postfix postfix-pgsql postfix-pcre cyrus-sasl syslog-ng

RUN postconf -e mydestination="localhost.localdomain, localhost" && \
  postconf -e smtpd_banner='$myhostname ESMTP $mail_name' && \
  postconf -# myhostname && \
  postconf -e inet_protocols=ipv4 && \
  postconf -e "smtpd_sasl_auth_enable = yes" && \
  postconf -e "smtpd_sasl_path = smtpd" && \
  postconf -e "cyrus_sasl_config_path = /etc/postfix/sasl" && \
  mkdir /etc/postfix/sasl && \
  mkdir /var/spool/filter && \
  chown nobody /var/spool/filter && \
  apk add --allow-untrusted /tmp/libs/$(uname -m)/cyrus-sasl-sql-2.1.28-r9.apk && \
  rm -rf /tmp/libs


ENV POSTFIX_PATH="/usr/libexec/postfix/master"

COPY ./etc/postfix/sasl/smtpd.conf /etc/postfix/sasl
COPY ./etc/postfix/aliases /etc/postfix/aliases
COPY ./etc/service/postfix /etc/service/postfix
COPY ./etc/service/saslauthd /etc/service/saslauthd
COPY ./etc/service/syslog-ng /etc/service/syslog-ng
COPY ./usr/local/bin /usr/local/bin
COPY ./etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
COPY ./usr/libexec/postfix/postfix-script /usr/libexec/postfix/postfix-script
