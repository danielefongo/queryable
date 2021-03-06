defmodule Queryable.Sample do
  use Ecto.Schema
  use Queryable

  schema "sample" do
    field(:name, :string)
    field(:surname, :string)
    field(:age, :integer)
  end

  criteria(el, {:name, name}, where: el.name == ^name)
  criteria(el, {:surname, surname}, where: el.surname == ^surname)
  criteria(el, {:order_by, field}, order_by: ^field)
end
