FROM ruby:3.1.2-alpine

RUN apk update \
    && apk add --update --no-cache build-base tzdata libpq postgresql-dev git

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "80"]