FROM nginx:1.25

RUN rm -f /etc/nginx/conf.d/*
COPY ./infra/nginx/nginx.conf /etc/nginx/nginx.conf
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
