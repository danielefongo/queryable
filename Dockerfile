FROM elixir:1.10-alpine

RUN mix local.hex --force
RUN mix local.rebar --force