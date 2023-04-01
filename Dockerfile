FROM nginx
COPY . /usr/share/nginx/html/
WORKDIR /usr/share/nginx/html/
RUN curl install
EXPOSE 80
