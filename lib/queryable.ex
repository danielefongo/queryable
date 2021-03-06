defmodule Queryable do
  def hello, do: :ok

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
      defp apply_criteria({unquote(key), unquote(value)}, query) do
        from([el] in query, unquote(body))
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      defp apply_criteria({key, value}, query) when not is_nil(value) do
        from([el] in query, where: field(el, ^key) == ^value)
      end

      defp apply_criteria({_key, value}, query) when is_nil(value), do: query
    end
  end
end
