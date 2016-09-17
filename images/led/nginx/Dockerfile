FROM nesslinger/docker-alpine-java

RUN adduser -D -g sudo -u 1000 -h /home/led led && \
    chown -R led:led /home/led



#==================================================================================
#==================================================================================
# ============ NGINX SETUP
#==================================================================================
#==================================================================================
# Install nginx
RUN apk add --update nginx && \
    rm -rf /var/cache/apk/* && \
    adduser www-data -G www-data -H -s /bin/false -D && \
    # chmod 777 /var/lib/nginx && \
    # chown -R led:led /var/lib/nginx && \
     chmod 777 /var/log/nginx && \
     chmod 777 /var/run/ && \
    # chown -R led:led /var/log/nginx && \
    chown -R led:www-data /var/lib/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY includes/ /etc/nginx/includes/
COPY 404.html /var/www/html/
COPY index.html /var/www/html


COPY ./start.sh /
RUN sed -i 's/\r$//' /start.sh && chmod +x /start.sh

# Expose the ports for nginx
EXPOSE 80 443

USER led

ENTRYPOINT ["/start.sh" ]
CMD [""]
