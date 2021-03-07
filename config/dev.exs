use Mix.Config

config :queryble, Queryable.Repo,
  database: "queryable",
  username: "queryable",
  password: "queryable",
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: System.get_env("POSTGRES_PORT", "5432")

config :queryble, ecto_repos: [Queryable.Repo]
