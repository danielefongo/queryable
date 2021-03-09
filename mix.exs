defmodule Queryable.MixProject do
  use Mix.Project

  @github "https://github.com/danielefongo/queryable"
  @version "0.1.0"

  def project do
    [
      app: :queryable,
      description: "Enhance Ecto with powerful queries",
      source_url: @github,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      package: [
        links: %{"GitHub" => @github},
        licenses: ["GPL-3.0-or-later"]
      ],
      docs: [
        main: "readme",
        extras: ["README.md", "LICENSE"],
        source_ref: "v#{@version}",
        source_url: @github
      ]
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
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.4.1", only: [:dev, :test]},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.init": ["ecto.create --quiet", "ecto.migrate --quiet --migrations-path test/migrations"],
      "format.all": [
        "format mix.exs 'lib/**/*.{ex,exs}' 'test/**/*.{ex,exs}' 'config/*.{ex,exs}'"
      ],
      "format.check": [
        "format --check-formatted mix.exs 'lib/**/*.{ex,exs}' 'test/**/*.{ex,exs}' 'config/*.{ex, exs}'"
      ],
      check: [
        "compile --all-warnings --ignore-module-conflict --warnings-as-errors --debug-info",
        "format.check",
        "credo"
      ],
      test: ["ecto.init", "test"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
