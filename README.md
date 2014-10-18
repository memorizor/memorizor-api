# Memorizor API [![Build Status](http://img.shields.io/travis/memorizor/memorizor-api.svg?style=flat)](https://travis-ci.org/memorizor/memorizor-api) [![Dependency Status](http://img.shields.io/gemnasium/memorizor/memorizor-api.svg?style=flat)](https://gemnasium.com/memorizor/memorizor-api) [![Code Climate](http://img.shields.io/codeclimate/github/memorizor/memorizor-api.svg?style=flat)](https://codeclimate.com/github/memorizor/memorizor-api) [![Test Coverage](http://img.shields.io/codeclimate/coverage/github/memorizor/memorizor-api.svg?style=flat)](https://codeclimate.com/github/memorizor/memorizor-api)


This is the home of the Memorizor API.

## Running the Memorizor API

We highly recommend using [vagrant](https://www.vagrantup.com/) to develop memorizor. It will install all of memorizor's dependancies and set up the databases for you. This allows you to mirror the production enviornment of memorizor as closely as possible.

Running `vagrant up` will set up everything for you.
You can then run `vagrant ssh` to ssh into the app.
You can start the app by running `cd /vagrant && rails s`, and view it on your local computer at `localhost:3000`.
When you're done, just run `vagrant halt` to shut down the app.

## Testing

Memorizor uses the build in rails testing tools and minitest.
You can run the tests with `bundle exec rake test`.

## Code Style

Memorizor adheres to the [rubocop style guide](https://github.com/bbatsov/ruby-style-guide).
You can run our code linter with `bundle exec rake rubocop`

## Mail Catcher

In the vagrant environment, all mail sent is caught by mailcatcher and can be viewed at `localhost:1080`.
