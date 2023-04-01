FROM nginx
COPY . /usr/share/nginx/html/
WORKDIR /usr/share/nginx/html/
EXPOSE 80
ENTRYPOINT ["./entrypoint.sh"]