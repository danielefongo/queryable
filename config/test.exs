use Mix.Config

config :queryable, Queryable.Repo,
  database: "queryable",
  username: "queryable",
  password: "queryable",
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: System.get_env("POSTGRES_PORT", "5432"),
  pool: Ecto.Adapters.SQL.Sandbox

config :queryable, ecto_repos: [Queryable.Repo]
