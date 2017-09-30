FROM ubuntu:xenial
MAINTAINER Michael Ruettgers <michael@ruettgers.eu>

ENV DEBIAN_FRONTEND noninteractive

RUN \
	# Update package repo and upgrade system
	apt-get update && apt-get upgrade -y

RUN \
	# Install build packages and common stuff
	export BUILD_PACKAGES="curl software-properties-common" && \
	export PACKAGES="rsync openssh-client" && \
	apt-get install -y ${BUILD_PACKAGES} ${PACKAGES}

RUN \
	# Install PHP and extensions
	LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
	apt-get update && \
	apt-get install -y \
		php7.1-cli \
		php7.1-curl \
		php7.1-gd \
		php7.1-xml \
		php7.1-bcmath \
		php7.1-mcrypt \
		php7.1-mysql \
		php7.1-mbstring \
		php7.1-opcache \
		php7.1-zip \
		php7.1-sqlite \
		php7.1-soap \
		php7.1-json \
		php7.1-intl \
		php7.1-bz2
	
RUN \
	# Cleanup
	apt-get purge ${BUILD_PACKAGES} && \
	apt-get -y autoremove && \
	apt-get -y clean

RUN \
	# Composer
	curl -sS https://getcomposer.org/installer | php && \
	mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer self-update

RUN \
	# PHPUnit
	curl -sS -o /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar && \
	chmod +x /usr/local/bin/phpunit

RUN \
	# Node.js
	curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
	apt-get install nodejs -y