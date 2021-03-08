defmodule Queryable.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :queryable,
    adapter: Ecto.Adapters.Postgres
end
