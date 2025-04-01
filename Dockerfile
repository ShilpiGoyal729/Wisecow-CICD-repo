FROM debian:latest  

RUN apt-get update && apt-get install -y \
    nginx cowsay fortune-mod perl netcat-openbsd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/games:${PATH}"

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY ./dist /usr/share/nginx/html

COPY wisecow.sh /usr/local/bin/wisecow.sh
RUN chmod +x /usr/local/bin/wisecow.sh

EXPOSE 4499

CMD ["/bin/sh", "-c", "/usr/local/bin/wisecow.sh & exec nginx -g 'daemon off;'"]
