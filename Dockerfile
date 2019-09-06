FROM bitwalker/alpine-elixir-phoenix:latest

ARG phoenix_port
ENV APP /opt/app/

RUN mkdir -p $APP
WORKDIR $APP
EXPOSE $phoenix_port
COPY . $APP

ADD . .

RUN ["chmod", "+x", "./docker-entrypoint.sh"]

ENTRYPOINT ["sh", "./docker-entrypoint.sh"]