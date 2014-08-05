# Memorizor API

This is the home of the Memorizor API.

## Running the Memorizor API

We highly reccomend using [vagrant](https://www.vagrantup.com/) to develop memorizor. It will install all of memorizor's dependancies and set up the databases for you. This allows you to mirror the production enviorment of memorizor as closely as possible.

Running `vagrant up` will set up everything for you.
You can then run `vagrant ssh` to ssh into the app.
You can start the app by runnning `cd /vagrant && rails s`, and view it on your local computer at `localhost:3000`.
When you're done, just run vagrant halt to shut down the app.
