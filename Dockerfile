FROM elixir:1.10.2-alpine

#RUN apt-get install -y curl \
 # && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
 # && apt-get install -y nodejs \
 # && curl -L https://www.npmjs.com/install.sh | sh

RUN apk update && apk upgrade && \
  apk add postgresql-client && \
  apk add nodejs npm && \
  apk add build-base && \
  rm -rf /var/cache/apk/*

ENV MIX_ENV dev

RUN mix do local.hex --force, local.rebar --force

COPY mix.* ./

RUN mix do deps.get --only dev
RUN mix deps.compile

COPY assets/package.json assets/
RUN cd assets && \
    npm install

COPY . ./
RUN cd assets/ && \
    npm run deploy && \
    cd - && \
    mix do compile, phx.digest

RUN chmod +x entrypoint.sh
CMD ["/entrypoint.sh"]