use Mix.Config

config :queryble, Queryable.Repo,
  database: "queryable",
  username: "queryable",
  password: "queryable",
  hostname: System.get_env("DB_HOSTNAME", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

config :queryble, ecto_repos: [Queryable.Repo]
