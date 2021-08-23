FROM mafio69/phpdebian:0.05 AS builder

USER root
WORKDIR /
ENV DEBIAN_FRONTEND=noninteractive \
  APP_NAME="CCFOUND" \
  DATABASE_NAME="ccfound" \
  DATABASE_USER="test" \
  DATABASE_PASSWORD=1234 \
  DATABASE_ROOT_PASSWORD=4567 \
  APP_ENV=dev \
  DEBUG=0 \
  XDEBUG=1 \
  LOCAL_PORT=8070 \
  DATABASE_PORT=3306 \
  EMAIL_USER=test \
  EMAIL_PASSWORD=test \
  EMAIL_HOST=mailtrap \
  VAR_DUMPER_SERVER=/main/var/log \
  DB_HOST_LOCAL=database \
  DB_HOST=localhost \
  SOCKET=$DB_URL \
  SERVERNAME=api.ccfound.test \
  SERVERALIAS=www.api.ccfound.test \
  DB_URL=$DB_URL \
  MAILER_DSN=$MAILER_DNS \
  MESSENGER_TRANSPORT_DSN=doctrine://default
COPY config/cron-task /etc/cron.d/crontask
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/enabled-symfony.conf /etc/nginx/conf.d/enabled-symfony.conf

RUN usermod -a -G docker root && adduser \
       --system \
       --shell /bin/bash \
       --disabled-password \
       --home /home/docker \
       docker \
       && usermod -a -G docker root \
       && usermod -a -G docker docker \
       && rm -f /etc/supervisor/conf.d/supervisord.conf \
       && touch -c /var/log/cron/cron.log \
       && touch -c /usr/share/nginx/logs/error.log

COPY config/cron-task /etc/cron.d/crontask
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/supervisord-main.conf /etc/supervisord.conf
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/enabled-symfony.conf /etc/nginx/conf.d/enabled-symfony.conf
COPY --chown=docker:docker /main /main
RUN  mkdir -p /var/log/cron/ \
        && ln -sf /main/var/log/local.log stdout\
        && ln -sf /var/log/nginx/project_access.log stdout \
        && ln -sf /dev/stdout /var/log/nginx/access.log \
    	&& ln -sf /dev/stderr /var/log/nginx/error.log \
    	&& mkdir -p /usr/share/nginx/logs/ \
    	&& mkdir -p /var/log/nginx/ \
    	&& mkdir -p /var/lib/nginx/body \
    	&& chmod 777 -R /var/lib/nginx/ \
    	&& chmod 777 -R /var/log/

STOPSIGNAL SIGQUIT
EXPOSE 8080 9000


FROM builder
WORKDIR /main
RUN bash -c  /main/entrypoint.sh \
    && composer require \
    && composer dump-autoload \
    && chown docker:docker -R /main/vendor
STOPSIGNAL SIGQUIT
EXPOSE 8080 9000
RUN chmod 777 -R  /usr/share && touch -c /usr/share/nginx/logs/error.log
CMD ["supervisord", "-n"]



