# CaddyServer with PHP-FPM

This is a simple Docker image to run CaddyServer with PHP-FPM.

## Usage

The following examples use images that have already been built; you can build your own images as described below.

### Single Container

- Configure your Caddyfile and place it in a folder on your host. Exapmle:

```plaintext
{
    email admin@rainss.cn
}
example.com:80 {
    encode gzip
    root * /www/websites
    php_fastcgi localhost:9000
    file_server
}
```

- Run the container with the following command. Example:

```bash
docker run -d -p 80:80 -p 443:443 -v /path/to/your/Caddyfile:/etc/caddy/Caddyfile -v /path/to/your/site:/www/websites --name caddyserver-php-fpm rainautos/caddyserver-php-fpm
```

### Docker Compose [Multi-container]

You can use Docker Compose to run CaddyServer with PHP-FPM. For example:

- Configure your Caddyfile and Using the following command to create a container.

```plaintext
{
    email admin@rainss.cn
}
example.com:80 {
    encode gzip
    root * /www/websites
    # notice: php-fpm is the name of the container
    php_fastcgi php-fpm:9000
    file_server
}
```

#### Using Dockerfile

```bash
version: '3'
services:
  webservice:
    container_name: caddy
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - ${PWD}/Caddyfile:/etc/caddy/Caddyfile
      - ${PWD}/config:/config
      - ${PWD}/data:/data
      - ${PWD}/websites:/www/websites
    depends_on:
      - php-cgi
    restart: unless-stopped
    networks:
      - website
  php-cgi:
    container_name: php-fpm
    build:
      context: ./php-fpm/8.2
      dockerfile: Dockerfile
    volumes:
      - ${PWD}/websites:/www/websites
    restart: unless-stopped
    networks:
      - website
networks:
  website:
    driver: bridge
```

#### Using Repository Image

```bash
```yaml
version: '3'
services:
  webservice:
    container_name: caddy
    image: caddy:latest
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - /etc/localtime:/etc/localtime
      - ${PWD}/Caddyfile:/etc/caddy/Caddyfile
      - ${PWD}/opt/caddy/config:/config
      - ${PWD}/opt/caddy/data:/data
      - ${PWD}/websites:/www/websites
    depends_on:
      - php-cgi
    restart: always
    networks:
      - website
  php-cgi:
    container_name: php-fpm
    image: rainautos/php-fpm:8.1.15
    volumes:
      - /etc/localtime:/etc/localtime
      - ${PWD}/websites:/www/websites
    restart: always
    networks:
      - website
networks:
  website:
    driver: bridge
```
## Build images

You can find the Dockerfiles in the `supervisor` or `php-fpm` folder to build the images.

### Build Caddy + PHP-FPM image

```bash
cd caddy-with-php/supervisor
docker build -t rainautos/caddyserver-php-fpm:latest .
```

### Build PHP-FPM image

```bash
cd php-fpm/8.3
docker build -t rainautos/php-fpm:latest .
```