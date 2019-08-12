FROM bitwalker/alpine-elixir-phoenix:latest

RUN apk --no-cache add --update                                         \
        --repository http://dl-3.alpinelinux.org/alpine/edge/testing/   \
        dos2unix

ARG phoenix_port
ENV APP /opt/app/

RUN mkdir -p $APP
WORKDIR $APP
EXPOSE $phoenix_port
COPY . $APP

COPY . .

RUN ["chmod", "+x", "./docker-entrypoint.sh"]

RUN ["dos2unix", "docker-entrypoint.sh"]

CMD ["sh", "./docker-entrypoint.sh"]