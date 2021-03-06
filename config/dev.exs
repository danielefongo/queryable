use Mix.Config

config :queryble, Queryable.Repo,
  database: "queryable",
  username: "queryable",
  password: "queryable",
  hostname: System.get_env("DB_HOSTNAME", "localhost")

config :queryble, ecto_repos: [Queryable.Repo]
