FROM nginx:1.9

# New default conf containing the proxy config
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Backend not found html response
COPY ./404.html /var/www/html/

COPY ./index.html /var/www/html/

# Nginx Proxy and SSL shared configs
COPY ./includes/ /etc/nginx/includes/
