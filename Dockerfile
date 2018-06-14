FROM php:5.6-apache
RUN docker-php-source extract \
&& apt-get update \
&& apt-get install libmcrypt-dev libldap2-dev libxml2-dev nano -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libapache2-mod-security2 \
        libxslt-dev \
        libicu-dev\ 
        ssmtp \
        git

RUN curl -sS https://getcomposer.org/installer | php \
&& mv composer.phar /usr/local/bin/composer

RUN docker-php-ext-install -j$(nproc) iconv mcrypt \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
&& docker-php-ext-install ldap pdo pdo_mysql xml json opcache session mbstring mysqli soap zip mcrypt xsl intl

# Install Postgre
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

RUN pecl install redis \
    && pecl install xdebug-2.5.5 \
&& docker-php-ext-enable redis xdebug

RUN a2enmod rewrite \
&& a2enmod ssl \
&& a2enmod security2 \
&& a2enmod headers

RUN rm -rf /var/lib/apt/lists/* \
&& docker-php-source delete