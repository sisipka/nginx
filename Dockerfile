FROM nginx
COPY . /usr/share/nginx/html/
WORKDIR /usr/share/nginx/html/
RUN apt update; curl install -y
EXPOSE 80
