FROM mafio69/phpdebian:v0.09
# AS builder

USER root
WORKDIR /
ENV DEBIAN_FRONTEND=noninteractive \
  APP_ENV=dev \
  DEBUG=0 \
  XDEBUG=0
COPY config/cron-task /etc/cron.d/crontask
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/enabled-symfony.conf /etc/nginx/conf.d/enabled-symfony.conf
RUN  mkdir -p /var/log/cron/ \
        && ln -sf /main/var/log/local.log stdout\
        && ln -sf /var/log/nginx/project_access.log stdout \
    	&& mkdir -p /usr/share/nginx/logs/ \
    	&& mkdir -p /var/log/nginx/ \
    	&& mkdir -p /var/lib/nginx/body \
    	&& chmod 777 -R /var/lib/nginx/ \
    	&& chmod 777 -R /var/log/ \
        && usermod -a -G docker root && adduser \
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
COPY config/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY config/cron-task /etc/cron.d/crontask
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/supervisord-main.conf /etc/supervisord.conf
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/enabled-symfony.conf /etc/nginx/conf.d/enabled-symfony.conf
COPY --chown=docker:docker /main /main

STOPSIGNAL SIGQUIT
EXPOSE 8080 9000
CMD ["supervisord", "-n"]

#FROM builder
#WORKDIR /main
#RUN bash -c  /main/entrypoint.sh \
#    && composer require \
#    && composer dump-autoload \
#    && chown docker:docker -R /main/vendor
#STOPSIGNAL SIGQUIT
#EXPOSE 8080 9000
#RUN chmod 777 -R  /usr/share && touch -c /usr/share/nginx/logs/error.log
#CMD ["supervisord", "-n"]



