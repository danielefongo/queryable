defmodule Queryable.Sample do
  use Ecto.Schema

  schema "sample" do
    field(:name, :string)
    field(:surname, :string)
    field(:age, :integer)
  end
end
