defmodule DbTest do
  @moduledoc false
  defmacro __using__(_) do
    quote do
      alias Queryable.Repo

      setup do
        Ecto.Adapters.SQL.Sandbox.checkout(Repo)
        :ok
      end

      defp insert(elements), do: Enum.each(elements, &Repo.insert/1)

      defp find(schema, criteria) do
        criteria
        |> schema.query()
        |> Repo.all()
      end
    end
  end
end
