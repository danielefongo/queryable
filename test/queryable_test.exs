defmodule QueryableTest do
  use ExUnit.Case
  use DbTest

  describe "on keyword query" do
    test "find inserted objects using single criteria" do
      insert([%Sample{name: "foo", age: 18}, %Sample{name: "foo", age: 17}])

      assert [_, _] = find(under: 19)
      assert [_] = find(under: 18)
      assert [] = find(under: 17)
    end

    test "find inserted objects using default criteria (schema fields)" do
      insert([%Sample{name: "foo", surname: "bar"}])

      assert [_] = find(name: "foo")
      assert [_] = find(surname: "bar")
    end

    test "find inserted objects using multiple criteria" do
      insert([%Sample{name: "foo", surname: "bar", age: 17}])

      assert [_] = find(name: "foo", under: 18)
      assert [] = find(name: "invalid", under: 18)
    end

    test "find inserted objects and sorting them" do
      insert([%Sample{name: "foo", surname: "baz"}, %Sample{name: "foo", surname: "bar"}])

      [first, second] = find(name: "foo", ordered_by: :surname)

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
