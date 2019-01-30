defmodule Cid.MixProject do
  use Mix.Project

  def project do
    [
      app: :cid,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test, all_tests: :test]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_multihash, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:basefiftyeight, "~> 0.1.0"}, # Currenly building our own version of this here https://git.io/fhPaK. Can replace when it is ready
      {:excoveralls, "~> 0.10", only: :test},
      {:stream_data, "~> 0.4.2", only: :test}
    ]
  end

  defp aliases do
    [
      test: ["coveralls --exclude ipfs"],
      all_tests: ["coveralls.detail --include ipfs"]
    ]
  end
end
