defmodule Queryable do
  def hello, do: :ok

  defmacro __using__(_opts) do
    quote do
      import Ecto.Query

      def where(criteria) do
        query = from(el in __MODULE__)

        Enum.reduce(criteria, query, &apply_criteria/2)
      end
    end
  end
end
