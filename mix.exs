defmodule DistCache.Mixfile do
  use Mix.Project

  def project do
    [app: :dist_cache,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      #applications: [
      #  :riak_core,
      #  :logger,
      #  :eleveldb,
      #  :cuttlefish,
      #],
      mod: {DistCache, []}
    ]
  end

  defp deps do
    [
      {:riak_core, "~> 3.0", hex: :riak_core_ng},
      #{:eleveldb, "~> 2.2.20", override: true, compile: "rebar3 compile"},
      {:cuttlefish, "~> 2.0.11", override: true, compile: "rebar3 compile"},
    ]
  end
end
