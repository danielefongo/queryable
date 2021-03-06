defmodule Queryable.Sample do
  use Queryable

  schema "sample" do
    field(:name, :string)
    field(:surname, :string)
    field(:age, :integer)
  end

  criteria(under: age, where: el.age < ^age)
  criteria(ordered_by: field, order_by: ^field)
end
