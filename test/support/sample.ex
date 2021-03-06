defmodule Queryable.Sample do
  use Ecto.Schema
  use Queryable

  schema "sample" do
    field(:name, :string)
    field(:surname, :string)
    field(:age, :integer)
  end

  criteria {:name, name}, on: el do
    el.name == ^name
  end

  criteria {:surname, surname}, on: el do
    el.surname == ^surname
  end
end
