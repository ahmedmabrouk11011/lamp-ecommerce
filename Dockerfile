FROM php:8.0.10-apache-buster


# Update
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*


# Install useful tools and install important libaries
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install nano wget \
dialog \
libsqlite3-dev \
libsqlite3-0 && \
    apt-get -y --no-install-recommends install default-mysql-client \
zlib1g-dev \
libzip-dev \
libicu-dev && \
    apt-get -y --no-install-recommends install --fix-missing apt-utils \
build-essential \
git \
curl \
libonig-dev && \ 
    apt-get -y --no-install-recommends install --fix-missing libcurl4 \
libcurl4-openssl-dev \
zip \
openssl && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Install xdebug
RUN pecl install xdebug-3.0.0 && \
    docker-php-ext-enable xdebug


WORKDIR /
COPY ./www /var/www/html
RUN echo "ServerName localhost:80" >> /etc/apache2/apache2.conf


# Other PHP8 Extensions

RUN docker-php-ext-install pdo_mysql && \
    docker-php-ext-install pdo_sqlite && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install curl && \
    docker-php-ext-install tokenizer && \
    docker-php-ext-install zip && \
    docker-php-ext-install -j$(nproc) intl && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install gettext && \
    docker-php-ext-install calendar && \
    docker-php-ext-install exif


EXPOSE 80

# Enable apache modules
RUN a2enmod rewrite headers

ENV MYSQL_ROOT_HOST=database-1.c5hdvwinjrid.us-west-1.rds.amazonaws.com:3306
ENV MYSQL_ROOT_USERNAME=root
ENV MYSQL_ROOT_PASSWORD=password

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]