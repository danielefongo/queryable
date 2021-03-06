defmodule Queryable do
  def hello, do: :ok

  defmacro __using__(_opts) do
    quote do
      require Queryable
      import Queryable
      import Ecto.Query

      def where(criteria) do
        query = from(el in __MODULE__)

        Enum.reduce(criteria, query, &apply_criteria/2)
      end
    end
  end

  defmacro criteria({key, value}, opts \\ [], do: body) do
    quote do
      defp apply_criteria({unquote(key), unquote(value)}, query) do
        where(query, [unquote(opts[:on])], unquote(body))
      end
    end
  end
end
