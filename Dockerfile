FROM alpine:3.6
MAINTAINER Kontena, Inc. <info@kontena.io>

RUN apk update && apk --update add tzdata ruby ruby-irb ruby-rdoc ruby-bigdecimal \
    ruby-io-console ruby-json ca-certificates libssl1.0 openssl libstdc++

ARG CLI_VERSION
ADD . /app/build

RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
    addgroup -S kosh && \
    adduser -SHD -G kosh -u 100 kosh -h /app && \
    cd /app/build && \
    gem build kontena-plugin-shell.gemspec && \
    gem install --no-ri --no-rdoc `ls -t kontena-plugin-shell*.gem|head -1` \
      kontena-plugin-digitalocean \
      kontena-plugin-aws \
      kontena-plugin-packet \
      kontena-plugin-upcloud \
      kontena-plugin-cloud && \
    cd /app && rm -rf build && \
    chown -R kosh:kosh /app/ && \
    apk del build-dependencies

WORKDIR /app
ENTRYPOINT kosh
USER kosh
