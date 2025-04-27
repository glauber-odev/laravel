# Use uma imagem base com PHP e Apache
FROM php:8.1-apache

# Defina o diretório de trabalho
WORKDIR /var/www/html

# Habilite os módulos do Apache necessários
RUN a2enmod rewrite

# Instalar dependências do sistema e extensões do PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql

# Instalar o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar os arquivos da aplicação Laravel para o contêiner
COPY . /var/www/html

# Instalar dependências do Laravel via Composer
RUN composer install --no-dev --optimize-autoloader

# Definir as permissões corretas para as pastas de armazenamento e cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Defina as variáveis de ambiente, como APP_KEY (se necessário) e DB_CONNECTION
ENV APP_KEY=base64:your_app_key_here
ENV DB_CONNECTION=mysql
ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_DATABASE=your_database
ENV DB_USERNAME=your_username
ENV DB_PASSWORD=your_password

# Expõe a porta 80 para o Apache
EXPOSE 80

# Comando para iniciar o Apache
CMD ["apache2-foreground"]
