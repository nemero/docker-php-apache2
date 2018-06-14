FROM php:5.6-apache
RUN docker-php-source extract \
&& apt-get update \
&& apt-get install libmcrypt-dev libldap2-dev libxml2-dev nano -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libapache2-mod-security2 \
        libxslt-dev \
        libicu-dev\ 
        ssmtp \
        git \
&& curl -sS https://getcomposer.org/installer | php \
&& mv composer.phar /usr/local/bin/composer \
&& docker-php-ext-install -j$(nproc) iconv mcrypt \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
&& rm -rf /var/lib/apt/lists/* \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
&& docker-php-ext-install ldap pdo pdo_mysql xml json opcache session mbstring mysqli soap zip mcrypt xsl intl pdo_pgsql \
&& docker-php-ext-enable mysqli \
&& pecl install redis \
    && pecl install xdebug \
&& docker-php-ext-enable redis xdebug \
&& a2enmod rewrite \
&& a2enmod ssl \
&& a2enmod security2 \
&& a2enmod headers \
&& docker-php-source delete