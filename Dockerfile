ARG WORDPRESS_IMAGE_TAG=apache
FROM wordpress:${WORDPRESS_IMAGE_TAG}

RUN set -x && \
	apt-get update && \
	apt-get install -y libldap2-dev && \
	docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
	docker-php-ext-install ldap && \
	apt-get purge -y --auto-remove libldap2-dev && \
	rm -rf /var/lib/apt/lists/*