FROM php:8.2-fpm
ENV LIBEVENT_VERSION=2.0.22
## INTL / MB_STRING
RUN apt-get update -qq
RUN apt-cache search zmq
RUN apt-get -qqy install \
    libicu-dev \
    zlib1g-dev \
    libpng-dev \
    libmcrypt-dev

#RUN docker-php-ext-install \
#    intl \
#    mbstring \
#    bcmath \
#    gd

RUN apt-get install -y \
    zlib1g-dev \
    libzip-dev
RUN docker-php-ext-install zip

##########################
## gettext for envsubst ##
##########################
RUN apt-get install gettext -y

#############
##   PDO   ##
#############
RUN docker-php-ext-install pdo
RUN docker-php-ext-configure pdo_mysql && docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

##############
## COMPOSER ##
##############

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

##############
##   YARN   ##
##############
RUN apt-get update && apt-get install -my wget gnupg
RUN apt-get install -y build-essential

#RUN node --version
#RUN npm --version
#RUN apt-get install -y npm
#RUN npm install --global yarn

RUN apt-get update && apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql

RUN #pecl install redis-3.1.6 && docker-php-ext-enable redis
#############
## SYMFONY ##
#############
    # Install xdebug
#    ARG SYMFONY_ENV
#    RUN if [ $SYMFONY_ENV = "dev" ]; then pecl install xdebug-2.9.8 ; fi
#    RUN if [ $SYMFONY_ENV = "dev" ]; then docker-php-ext-enable xdebug ; fi
#    RUN if [ $SYMFONY_ENV = "dev" ]; then echo "error_reporting = E_ALL"          >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi
#    RUN if [ $SYMFONY_ENV = "dev" ]; then echo "display_startup_errors = On"      >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi
#    RUN if [ $SYMFONY_ENV = "dev" ]; then echo "display_errors = On"              >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi
#    RUN if [ $SYMFONY_ENV = "dev" ]; then echo "xdebug.remote_enable=1"           >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi
#    RUN if [ $SYMFONY_ENV = "dev" ]; then echo "xdebug.remote_connect_back=1"     >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi
#    RUN if [ $SYMFONY_ENV = "dev" ]; then echo "xdebug.idekey=PHPSTORM"       >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi
#    RUN if [ $SYMFONY_ENV = "dev" ]; then echo "xdebug.remote_port=9001"          >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi
#    RUN if [ $SYMFONY_ENV = "dev" ]; then echo "xdebug.max_nesting_level=1000"    >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi

#RUN apt-get update -yqq
RUN apt-get update

RUN apt-get --allow-releaseinfo-change update && apt-get install -y wkhtmltopdf xvfb

#User
ARG PHP_GNAME
ARG PHP_GID
ARG PHP_UID
ARG PHP_UNAME


RUN useradd --create-home --user-group --shell /bin/bash --uid $PHP_UID $PHP_UNAME
RUN usermod -aG www-data $PHP_UNAME
RUN bash -c "echo \$(id -u www-data):\$(id -g www-data)"
RUN groupadd -g $PHP_GID $PHP_GNAME
RUN usermod -aG $PHP_GNAME $PHP_UNAME
RUN mkdir -p /home/$PHP_UNAME/workdir
RUN chown -R $PHP_UNAME:$PHP_GNAME /home/$PHP_UNAME/workdir

# Install Nodejs
#ARG NODE_VERSION
#RUN apt install -y curl
#RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
#ENV NVM_DIR=/root/.nvm
#RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
#RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
#RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
#ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs
#Aliases
ADD aliases.sh /home/$PHP_UNAME
ARG SYMFONY_ENV
ARG SYMFONY_WORKDIR
RUN envsubst '$$SYMFONY_ENV' < "/home/$PHP_UNAME/aliases.sh" > "/home/$PHP_UNAME/.bash_aliases"
WORKDIR  /home/$PHP_UNAME/workdir/$SYMFONY_WORKDIR
