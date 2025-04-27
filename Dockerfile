# Usar uma imagem oficial do PHP com Apache
FROM php:8.1-apache

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /var/www/html

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

# Habilitar mod_rewrite no Apache
RUN a2enmod rewrite

# Instalar o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar os arquivos da aplicação Laravel para o contêiner
COPY . /var/www/html

# Rodar o Composer para instalar as dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# Ajustar permissões para as pastas de cache e armazenamento
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Definir a variável de ambiente APP_KEY, caso necessário
ENV APP_KEY=base64:your_app_key_here

# Expor a porta 80 do contêiner
EXPOSE 80

# Iniciar o Apache no primeiro plano
CMD ["apache2-foreground"]
