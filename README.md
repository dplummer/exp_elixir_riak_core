# Experiment with Elixir and Riak Core

Trying to use riak_core in Elixir.

## Resources

* https://github.com/project-fifo/riak_core
* https://github.com/kanatohodets/elixir_riak_core_ping
* https://medium.com/@GPad/create-a-riak-core-application-in-elixir-part-1-41354c1f26c3#.hxzh5zaw7

## Installation

Use Erlang/OTP 18

1. Clone this repo
2. Run `mix deps.get`
3. Run `iex --name node1@127.0.0.1 -S mix run`

And it should work.

## Docker

It doesn't build with docker yet. If it did, just running `docker build .`
should build an image.
