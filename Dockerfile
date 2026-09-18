# Stage 1: Build Frontend
FROM node:26-alpine AS frontend-builder
WORKDIR /app 
COPY package*.json ./
COPY vite.config.js ./
COPY tsconfig.json ./
WORKDIR /app/client
COPY client/ ./
WORKDIR /app 
RUN ls -l /app/
RUN npm ci
RUN npm run build

# Stage 2: Build Backend Dependencies
FROM composer:2 AS composer-builder
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --verbose --prefer-dist --no-interaction --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs

# Stage 3: Production Image
FROM php:8.4-fpm

# 1. Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libbz2-dev \
    libicu-dev \
    default-mysql-client \
    zip unzip curl git make gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Configure & install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install \
    gd \
    pdo \
    pdo_mysql \
    mbstring \
    xml \
    zip \
    bcmath \
    gmp \
    intl \
    curl \
    opcache


# 3. Setup app
WORKDIR /var/www/html

# Copy backend code
COPY --from=composer-builder /app/vendor ./vendor
COPY src ./src
COPY var/config/ ./var/config
COPY public ./public
COPY .env ./

# Copy built frontend assets
COPY --from=frontend-builder /app/client/dist ./public/
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Install Nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# Nginx configuration -> example config, update this for deployment.
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/sites-enabled/default

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]