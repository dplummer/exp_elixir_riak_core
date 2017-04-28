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
      {:cuttlefish, "~> 2.0.11", override: true, manager: :rebar3, github: "basho/cuttlefish", branch: "rebar3"},
      {:lager, "~> 3.2", github: "basho/lager", branch: "rebar3", manager: :rebar3, override: true},
      {:goldrush, ">= 0.1.8", [env: :prod, github: "basho/goldrush", branch: "rebar3", manager: :rebar3, override: true]},
    ]
  end
end
