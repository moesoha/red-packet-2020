FROM php:7.4-fpm-buster
ENV LC_ALL=C.UTF-8
RUN sed -i -E 's/(deb|security).debian.org/ipv4.mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
	&& apt-get update && apt-get install -y gnupg curl vim psmisc procps \
	&& curl -sSL https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add - \
	&& curl -sSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
	&& echo "deb http://ipv4.mirrors.ustc.edu.cn/nginx/mainline/debian buster nginx" > /etc/apt/sources.list.d/nginx.list \
	&& echo "deb http://mirrors4.tuna.tsinghua.edu.cn/mongodb/apt/debian buster/mongodb-org/4.2 main" > /etc/apt/sources.list.d/mongodb.list \
	&& apt-get update && apt-get install -y nginx mongodb-org \
	&& cd $(mktemp -d) \
	&& pecl download mongodb \
	&& mkdir -p /usr/src/php/ext/mongodb && tar -C /usr/src/php/ext/mongodb --strip 1 -zxvf mongodb*tgz \
	&& docker-php-ext-install opcache mongodb \
	&& echo "All packages installed." \
	&& mkdir -p /app/prepare /app/www
ADD . /app/prepare/

RUN rm -f /etc/nginx/conf.d/default.conf /etc/php/7.2/fpm/pool.d/* \
	&& cp -v /app/prepare/_docker/run.sh /app/run.sh \
	&& cp -v /app/prepare/_docker/nginx.conf /etc/nginx/conf.d/www.conf \
	&& cp -v /app/prepare/_docker/php-fpm.ini /usr/local/etc/php-fpm.d/pool.conf \
	&& cd /app/prepare/lv2 && chmod a+x ./import_db.sh && ./import_db.sh \
	&& echo "deploying codes" \
	&& cp -vr /app/prepare/*/deploy/* /app/www/ \
	&& chown -R root /app/www && chmod 755 /app/www /app/run.sh

EXPOSE 80
CMD ["/app/run.sh"]