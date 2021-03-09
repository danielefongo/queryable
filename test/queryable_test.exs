defmodule QueryableTest do
  use ExUnit.Case
  use DbTest

  defmodule Sample do
    @moduledoc false
    use Queryable

    schema "sample" do
      field(:name, :string)
      field(:surname, :string)
      field(:age, :integer)
    end

    criteria(under: age, where: el.age < ^age)
    criteria(ordered_by: field, order_by: ^field)
  end

  describe "on keyword query" do
    test "find inserted objects using single criteria" do
      insert([%Sample{name: "foo", age: 18}, %Sample{name: "foo", age: 17}])

      assert [_, _] = find(Sample, under: 19)
      assert [_] = find(Sample, under: 18)
      assert [] = find(Sample, under: 17)
    end

    test "find inserted objects using default criteria (schema fields)" do
      insert([%Sample{name: "foo", surname: "bar"}])

      assert [_] = find(Sample, name: "foo")
      assert [_] = find(Sample, surname: "bar")
    end

    test "find inserted objects using multiple criteria" do
      insert([%Sample{name: "foo", surname: "bar", age: 17}])

      assert [_] = find(Sample, name: "foo", under: 18)
      assert [] = find(Sample, name: "invalid", under: 18)
    end

    test "find inserted objects and sorting them" do
      insert([%Sample{name: "foo", surname: "baz"}, %Sample{name: "foo", surname: "bar"}])

      [first, second] = find(Sample, name: "foo", ordered_by: :surname)

      assert first.surname == "bar"
      assert second.surname == "baz"
    end
  end

  describe "on builder query" do
    test "find inserted objects using single criteria" do
      insert([%Sample{name: "foo", age: 18}, %Sample{name: "foo", age: 17}])

      assert [_, _] = 19 |> Sample.under() |> Repo.all()
      assert [_] = 18 |> Sample.under() |> Repo.all()
      assert [] = 17 |> Sample.under() |> Repo.all()
    end

    test "find inserted objects using default criteria (schema fields)" do
      insert([%Sample{name: "foo", surname: "bar"}])

      assert [_] = "foo" |> Sample.name() |> Repo.all()
      assert [_] = "bar" |> Sample.surname() |> Repo.all()
    end

    test "find inserted objects using multiple criteria" do
      insert([%Sample{name: "foo", surname: "bar", age: 17}])

      assert [_] = Sample |> Sample.name("foo") |> Sample.under(18) |> Repo.all()
      assert [] = Sample |> Sample.name("invalid") |> Sample.under(18) |> Repo.all()
    end
  end
end
