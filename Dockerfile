FROM elixir:1.15.4-alpine AS build

ENV MIX_ENV=prod
ENV LANG=C.UTF-8
ENV PHX_HOST=0.0.0.0
ENV PHX_SERVER=true

COPY . .

RUN mix local.hex --force
RUN mix deps.get --only prod
RUN mix release

FROM alpine:3.18.4 AS run

ENV MIX_ENV=prod
ENV LANG=C.UTF-8
ENV PHX_HOST=0.0.0.0
ENV PHX_SERVER=true

RUN apk add build-base ncurses

WORKDIR /minecraft-skins

COPY --from=build _build/prod/rel/minecraft_skins/ .

CMD ["bin/minecraft_skins", "start"]
