defmodule Queryable.Sample do
  use Ecto.Schema
  use Queryable

  schema "sample" do
    field(:name, :string)
    field(:surname, :string)
    field(:age, :integer)
  end

  defp apply_criteria({:name, name}, query), do: where(query, [el], el.name == ^name)
  defp apply_criteria({:surname, surname}, query), do: where(query, [el], el.surname == ^surname)
end
