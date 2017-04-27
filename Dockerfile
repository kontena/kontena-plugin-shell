FROM ruby:2.3.3-alpine

RUN apk --update add ca-certificates libstdc++

RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
    gem install bundler --no-ri --no-rdoc

ADD . /app/build
RUN cd /app/build; \
    gem build kontena-plugin-shell.gemspec && \
    gem install `ls -t kontena-plugin-shell*.gem|head -1`; \
    cd ..; \
    rm -rf build

WORKDIR /app
ENTRYPOINT kosh
