FROM nginx:latest

WORKDIR /usr/share/nginx/html

COPY ./website /usr/share/nginx/html

# Copy the Nginx configuration file this only if you have ssl certificate and test https on local
#COPY ./nginx.conf /etc/nginx/nginx.conf
#COPY ./ssl /etc/nginx/ssl

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
