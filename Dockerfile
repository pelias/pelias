# This is a Dockerfile to run the Pelias website :)
# For some very awesome Dockerfiles to run Pelias itself,
# see https://github.com/pelias/docker/
FROM composer:latest

RUN composer global require couscous/couscous
RUN ln -s /tmp/vendor/bin/couscous /usr/local/bin

WORKDIR /home/
COPY . .

ENTRYPOINT [ "/usr/local/bin/couscous" ]

CMD [ "preview", "0.0.0.0:8000" ]
