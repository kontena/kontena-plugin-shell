FROM alpine:3.5
MAINTAINER Kontena, Inc. <info@kontena.io>

RUN apk update && apk --update add tzdata ruby ruby-irb ruby-rdoc ruby-bigdecimal \
    ruby-io-console ruby-json ca-certificates libssl1.0 openssl libstdc++

ARG CLI_VERSION
ADD . /app/build
RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app/build && \
    gem build kontena-plugin-shell.gemspec && \
    gem install `ls -t kontena-plugin-shell*.gem|head -1` && \
    rm -rf /app/build && \
    apk del build-dependencies

WORKDIR /app
ENTRYPOINT kosh
