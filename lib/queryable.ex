defmodule Queryable do
  @moduledoc """
  Queryable injects query utility functions inside an Ecto Schema.

  ## Example
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

  Using Queryable within an Ecto Schema creates a function `&query/1` that accepts a list of
  optional keywords, each one corresponding to a schema field or to a virtual field declared on
  a `criteria`, and returns an Ecto Query. A typical usage is the following:

      iex> Person.query(name: "John", under: 18)
      iex> #Ecto.Query<from s0 in Person, where: s0.name == ^"John", where: s0.age < ^18>

  Furthermore, for each field or virtual field, a builder function with the same name is created.
  For example, the previous query can be rewritten using builder:

      iex> Person.name("John") |> Person.under(18)
      iex> #Ecto.Query<from s0 in Person, where: s0.name == ^"John", where: s0.age < ^18>

  The latter option enables compile time checks (eg: dialyxir) if you want to be sure
  you are building the query properly.
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      require Queryable
      import Queryable
      import Ecto.Query
      @before_compile unquote(__MODULE__)

      def query(criteria) when is_list(criteria) do
        query = from(el in __MODULE__)

        Enum.reduce(criteria, query, &apply_criteria/2)
      end
    end
  end

  @doc """
  Create a virtual field that can be queried.

  ## Example
      criteria(under: age, where: el.age < ^age)
      criteria(ordered_by: field, order_by: ^field)

  You can also use pattern matching.

  ## Example
      criteria(age: [from, to], where: el.age >= ^from and el.age <= ^to)
      criteria(age: age, where: el.age == ^age)

  If you define a custom criteria for schema field, default query for that field will be replaced.

  N.B. Object must be referred using `el` keyword.
  """
  defmacro criteria([{field, value} | body]) do
    module = __CALLER__.module

    quote do
      unquote(setup_criteria(quote do: [unquote(module), unquote(field), unquote(value), unquote(body)]))
    end
  end

  defmacro __before_compile__(_env) do
    module = __CALLER__.module

    fields = Module.get_attribute(module, :fields, [])

    module
    |> Module.get_attribute(:changeset_fields)
    |> Enum.map(fn {field, _} -> field end)
    |> Enum.filter(fn field -> not Enum.member?(fields, field) end)
    |> Enum.map(fn field ->
      value = quote do: value
      body = quote do: [where: field(el, ^unquote(field)) == ^unquote(value)]

      setup_criteria(quote do: [unquote(module), unquote(field), unquote(value), unquote(body)])
    end)
  end

  defp setup_criteria([module, field, value, body]) do
    quote do
      fields = Module.get_attribute(unquote(module), :fields, [])

      if not Enum.member?(fields, unquote(field)) do
        Module.put_attribute(unquote(module), :fields, fields ++ [unquote(field)])
      end

      defp apply_criteria({unquote(field), unquote(value)}, query) do
        from([el] in query, unquote(body))
      end

      def unquote(field)(unquote(value)) do
        from([el] in unquote(module), unquote(body))
      end

      def unquote(field)(query, unquote(value)) do
        from([el] in query, unquote(body))
      end
    end
  end
end
