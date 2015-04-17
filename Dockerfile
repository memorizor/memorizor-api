FROM ruby:2.2.2-slim
RUN mkdir /memorizor

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /memorizor
WORKDIR /memorizor
