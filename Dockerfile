FROM bitwalker/alpine-elixir-phoenix:latest

ARG phoenix_port
ENV APP /opt/app/

RUN mkdir -p $APP
WORKDIR $APP
EXPOSE $phoenix_port
COPY . $APP

ADD . .

RUN mix deps.get --only-prod
RUN mix deps.compile
RUN mix compile

RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT ["sh", "./docker-entrypoint.sh"]