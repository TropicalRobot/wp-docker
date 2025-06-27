# Extend the official WordPress image
FROM wordpress:6.8.1-php8.2-apache

# Install Node.js (LTS) and npm
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get update \
  && apt-get install -y nodejs \
  && npm install -g npm

# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Add Xdebug config
COPY docker/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Enable Apache SSL modules
RUN a2enmod ssl
RUN a2ensite default-ssl

# Replace default-ssl.conf to point to your certs
RUN a2enmod ssl && a2ensite default-ssl && \
  sed -i 's|SSLCertificateFile.*|SSLCertificateFile /etc/apache2/ssl/cert.pem|' /etc/apache2/sites-available/default-ssl.conf && \
  sed -i 's|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/apache2/ssl/key.pem|' /etc/apache2/sites-available/default-ssl.conf

# Set working directory
WORKDIR /var/www/html