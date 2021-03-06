defmodule Queryable.Repo do
  use Ecto.Repo,
    otp_app: :queryble,
    adapter: Ecto.Adapters.Postgres
end
