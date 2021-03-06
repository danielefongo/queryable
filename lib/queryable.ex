defmodule Queryable do
  def hello, do: :ok

  defmacro __using__(_opts) do
    quote do
      require Queryable
      import Queryable
      import Ecto.Query

      def query(criteria) do
        query = from(el in __MODULE__)

        Enum.reduce(criteria, query, &apply_criteria/2)
      end
    end
  end

  defmacro criteria(on, {key, value}, body) do
    quote do
      defp apply_criteria({unquote(key), unquote(value)}, query) do
        from([unquote(on)] in query, unquote(body))
      end
    end
  end
end
