# Queryable

[![Continuous Integration](https://github.com/danielefongo/queryable/actions/workflows/elixir.yml/badge.svg)](https://github.com/danielefongo/queryable/actions/workflows/elixir.yml)
[![Hex pm](http://img.shields.io/hexpm/v/queryable.svg?style=flat)](https://hex.pm/packages/queryable)
![Hex.pm](https://img.shields.io/hexpm/l/queryable)

Enhance Ecto with powerful queries.

## Installation

The package can be installed by adding `queryable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:queryable, "~> 0.1.0"}
  ]
end
```

## Documentation

Documentation can be found at [https://hexdocs.pm/queryable](https://hexdocs.pm/queryable).

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

This query can then be passed to methods like `Repo.all`.