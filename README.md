# Queryable

Enhance Ecto with powerful queries.

## Installation

The package can be installed by adding `queryable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:queryable, git: "https://github.com/danielefongo/queryable.git"}
  ]
end
```

## Usage

Extend an Ecto Schema by adding criteria:

``` elixir
defmodule Person do
  use Queryable #instead of Ecto.Schema

  schema "persons" do
    field :name, :string
    field :surname, :string
    field :age, :integer
  end

  criteria(under: age, where: el.age < ^age)
  criteria(ordered_by: field, order_by: ^field)
end
```

Then create an Ecto Query in one of the following modes:

``` elixir
Person.query(name: "John", under: 18)
```

``` elixir
Person.name("John") |> Person.under(18)
```

Note that schema fields are automatically queryable.
This query can then be passed to methods like `Repo.all`.