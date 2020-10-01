FROM php:7.4.3-apache
RUN docker-php-source extract \
&& apt-get update \
&& apt-get install libldap2-dev libxml2-dev nano -y \
        libapache2-mod-security2 \
        libxslt-dev \
        libicu-dev \
        libpq-dev

# Install SMTP
# RUN apt-get install -y ssmtp

# Install GIT
RUN apt-get install -y git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/composer

# Install mcrypt
#RUN apt-get install -y libmcrypt-dev \
#        && docker-php-ext-install mcrypt

# Install Iconv
RUN docker-php-ext-install -j$(nproc) iconv

# Install ..
RUN apt-get update && \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        zip \
        libpng-dev \
        zlib1g-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        graphviz \
        #jpegoptim \
        #optipng \
        #pngquant \
        #gifsicle \
        unzip

# Install GD
RUN apt-get install -y libwebp-dev libxpm-dev
RUN docker-php-ext-configure gd \
		--enable-gd \
		#--with-external-gd \
		--with-jpeg \
		--with-xpm \
		--with-webp \
		--with-freetype

RUN     docker-php-ext-install gd

# Install Ldap
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
        && docker-php-ext-install ldap

# Install bcmath
RUN docker-php-ext-install bcmath

# Install Redis
RUN pecl install redis \
        && docker-php-ext-enable redis

# Install OPCache
RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache

# Install Other extenshions
RUN docker-php-ext-install pdo pdo_mysql xml json opcache session mbstring mysqli zip soap tokenizer xsl intl pdo_pgsql

RUN a2enmod rewrite \
        && a2enmod ssl \
        && a2enmod security2 \
        && a2enmod headers

RUN rm -rf /var/lib/apt/lists/* \
        && docker-php-source delete
