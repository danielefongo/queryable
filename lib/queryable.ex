defmodule Queryable do
  @moduledoc false
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

  defmacro criteria([{key, value} | body]) do
    quote do
      raw_criteria({unquote(key), unquote(value)}, do: unquote(body))
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      __MODULE__
      |> Module.get_attribute(:changeset_fields)
      |> Enum.map(fn {key, _} -> key end)
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
