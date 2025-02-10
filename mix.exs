defmodule Cid.MixProject do
  use Mix.Project

  def project do
    [
      app: :excid,
      version: "1.0.2",
      package: package(),
      description: description(),
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        c: :test,
        coveralls: :test,
        "coveralls.json": :test,
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_multihash, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:b58, "~> 1.0.3"},
      {:excoveralls, "~> 0.10", only: :test},
      {:stream_data, "~> 1.1.0", only: :test},
      {:ex_doc, "~> 0.37.1", only: :dev}
    ]
  end

  defp description() do
    "cid (\"content id\") is a human-friendly (readable/typeable) unique ID function built for distributed/decentralized systems."
  end

  defp package() do
    [
      name: "excid",
      licenses: ["GPL-2.0-or-later"],
      maintainers: ["dwyl"],
      links: %{"GitHub" => "https://github.com/dwyl/cid"}
    ]
  end

  defp aliases do
    [
      t: ["test"],
      c: ["coveralls.html"]
    ]
  end
end
