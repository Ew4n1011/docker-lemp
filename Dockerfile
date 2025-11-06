FROM php:fpm

# Install english language locale
RUN apt-get update && apt-get install -y \
    locales locales-all

# Install Git
RUN apt-get update && apt-get install git git-core -y

# Install various libraries used by PHP extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libpq-dev \
        g++ \
        libicu-dev \
        libxml2-dev \
        libmcrypt-dev \
        libonig-dev \
        libzip-dev \
        libmagickwand-dev --no-install-recommends

# Install various PHP extensions
RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install soap \
    #&& docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# install git
RUN apt-get update && apt-get install git git-core -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable logging
RUN echo "log_errors = On" >> /usr/local/etc/php/conf.d/log.ini \
&& echo "error_log=/dev/stderr" >> /usr/local/etc/php/conf.d/log.ini

# Cleanup
RUN apt-get purge --auto-remove -y g++ \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/listen.*/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.conf

RUN usermod -u 1000 www-data

WORKDIR /var/www/app

CMD ["php-fpm"]