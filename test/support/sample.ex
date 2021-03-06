defmodule Queryable.Sample do
  use Ecto.Schema
  use Queryable

  schema "sample" do
    field(:name, :string)
    field(:surname, :string)
    field(:age, :integer)
  end

  criteria({:name, name}, where: el.name == ^name)
  criteria({:surname, surname}, where: el.surname == ^surname)
  criteria({:order_by, field}, order_by: ^field)
end
