defmodule Queryable do
  @moduledoc """
  Queryable inject query utility functions inside an Ecto Schema.

  ## Example
      defmodule Person do
        use Queryable #instead of Ecto.Schema
        schema "persons" do
          field :name, :string
          field :surname, :string
          field :age, :integer
        end

        criteria(under: age, where: el.age < ^age)
      end

  By default, using Queryable within an Ecto Schema, creates a function `&query/1` that accepts a list of
  optional keywords, each one corresponding to a declared field or to one of the virtual fields declared on
  method `criteria`. A typical use can be the following:

      iex> Person.query(name: "John", under: 18)
      iex> #Ecto.Query<from s0 in Person, where: s0.name == ^"John", where: s0.age < ^18>

  Furthermore, for each field or virtual field, a builder function with the same name is created.
  For example, the previous query can be rewritten using builder:

      iex> Person.name("John") |> Person.under(18)
      iex> #Ecto.Query<from s0 in Person, where: s0.name == ^"John", where: s0.age < ^18>

  The latter option enables compile time checks (eg: credo+dialyxir) if you want to be sure
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

  You can also use pattern matching:

  ## Example
      criteria(age: [from, to], where: el.age < ^from and el.age < ^to)
      criteria(age: age, where: el.age == ^age)

  If you define a custom criteria for schema field, default query for that field will be replaced.
  """
  defmacro criteria([{key, value} | body]) do
    filters = Module.get_attribute(__CALLER__.module, :filters, [])

    if not Enum.member?(filters, key) do
      Module.put_attribute(__CALLER__.module, :filters, filters ++ [key])
    end

    quote do
      raw_criteria({unquote(key), unquote(value)}, do: unquote(body))
    end
  end

  defmacro __before_compile__(_env) do
    filters = Module.get_attribute(__CALLER__.module, :filters, [])

    quote do
      __MODULE__
      |> Module.get_attribute(:changeset_fields)
      |> Enum.map(fn {key, _} -> key end)
      |> Enum.filter(fn func -> not Enum.member?(unquote(filters), func) end)
      |> criteria_equal()
    end
  end

  defmacro criteria_equal(fields) do
    quote bind_quoted: [fields: fields] do
      Enum.each(fields, fn field ->
        raw_criteria({unquote(field), value}, do: [where: field(el, ^unquote(field)) == ^value])
      end)
    end
  end

  defmacro raw_criteria({atom, value}, _opts \\ [], do: body) do
    quote do
      defp apply_criteria({unquote(atom), unquote(value)}, query) do
        from([el] in query, unquote(body))
      end

      def unquote(atom)(unquote(value)) do
        from([el] in __MODULE__, unquote(body))
      end

      def unquote(atom)(query, unquote(value)) do
        from([el] in query, unquote(body))
      end
    end
  end
end
