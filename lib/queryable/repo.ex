defmodule Queryable.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :queryble,
    adapter: Ecto.Adapters.Postgres
end
