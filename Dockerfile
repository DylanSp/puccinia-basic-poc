###
### First Stage - Building the Release
###
FROM hexpm/elixir:1.12.1-erlang-24.0.1-ubuntu-focal-20210325 AS build

# install build dependencies

# necessary for installing tzdata without interactive configuration
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl build-essential

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install wasm-pack

# prepare build dir
WORKDIR /app

# extend hex timeout
ENV HEX_HTTP_TIMEOUT=20

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV as prod
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey

# Copy over the mix.exs and mix.lock files to load the dependencies. If those
# files don't change, then we don't keep re-fetching and rebuilding the deps.
COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only prod && \
  mix deps.compile

# install npm dependencies
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets install --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets

COPY native native

# NOTE: If using TailwindCSS, it uses a special "purge" step and that requires
# the code in `lib` to see what is being used. Uncomment that here before
# running the npm deploy script if that's the case.
# COPY lib lib

# build assets
RUN mix assets.deploy
RUN mix phx.digest

# copy source here if not using TailwindCSS
COPY lib lib

# compile and build release
COPY rel rel
RUN mix do compile, release

###
### Second Stage - Setup the Runtime Environment
###

# prepare release docker image
FROM ubuntu:focal AS app
RUN apt-get update && apt-get install -y openssl

WORKDIR /app

COPY --from=build /app/_build/prod/rel/puccinia_basic_poc ./

ENV HOME=/app
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey
ENV PORT=4000

CMD ["bin/puccinia_basic_poc", "start"]