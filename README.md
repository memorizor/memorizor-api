# Memorizor API [![Build Status](http://img.shields.io/travis/memorizor/memorizor-api.svg?style=flat)](https://travis-ci.org/memorizor/memorizor-api) [![Dependency Status](http://img.shields.io/gemnasium/memorizor/memorizor-api.svg?style=flat)](https://gemnasium.com/memorizor/memorizor-api) [![Code Climate](http://img.shields.io/codeclimate/github/memorizor/memorizor-api.svg?style=flat)](https://codeclimate.com/github/memorizor/memorizor-api) [![Test Coverage](http://img.shields.io/codeclimate/coverage/github/memorizor/memorizor-api.svg?style=flat)](https://codeclimate.com/github/memorizor/memorizor-api)


This is the home of the Memorizor API.

## Running the Memorizor API

We highly recommend using [docker compose](https://docs.docker.com/compose/) to run the Memorizor API. To start up the Memorizor API, run `docker-compose start`. To run commands in the Memorizor API container, run `docker-compose run web <command>`

## Testing

Memorizor uses the built in rails testing tools and minitest.
You can run the tests with `docker-compose run web bundle exec rake test`.

## Code Style

Memorizor adheres to the [rubocop style guide](https://github.com/bbatsov/ruby-style-guide).
You can run our code linter with `docker-compose run web bundle exec rake rubocop`

## Mail Catcher

In the vagrant environment, all mail sent is caught by mailcatcher and can be viewed at `localhost:1080`.
