defmodule DistCache.Mixfile do
  use Mix.Project

  def project do
    [app: :dist_cache,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:riak_core, :logger],
     mod: {DistCache, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:riak_core, "~> 2.2", hex: :riak_core_ng},
      #{:eleveldb, "~> 2.2", override: true},
      #{:cuttlefish, "~> 2.0.11", override: true},
      #{:lager, "~> 2.1.1", override: true},
      #{:goldrush, "~> 0.1.9", override: true},
    ]
  end
end
