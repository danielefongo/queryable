defmodule DbTest do
  @moduledoc false
  defmacro __using__(_) do
    quote do
      alias Queryable.{Repo, Sample}

      setup do
        Ecto.Adapters.SQL.Sandbox.checkout(Repo)
        :ok
      end

      defp insert(elements) when is_list(elements),
        do: Enum.each(elements, fn element -> Repo.insert(element) end)

      defp insert(element) when is_struct(element), do: Repo.insert(element)

      defp find(criteria) do
        criteria
        |> Sample.query()
        |> Repo.all()
      end
    end
  end
end
