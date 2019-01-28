defmodule Cid.MixProject do
  use Mix.Project

  def project do
    [
      app: :cid,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:basefiftyeight, "~> 0.1.0"} # Currenly building our own version of this here https://git.io/fhPaK. Can replace when it is ready
    ]
  end
end
