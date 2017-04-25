FROM ruby:2.3.3-alpine

RUN apk --update add ca-certificates libstdc++

RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
    gem install bundler --no-ri --no-rdoc

RUN gem install kontena-cli
RUN kontena plugin install shell

WORKDIR /app
ENTRYPOINT kontena shell
