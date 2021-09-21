FROM elixir:1.12
WORKDIR /app
COPY mix.exs .
RUN mix deps.get && mix compile
COPY . .