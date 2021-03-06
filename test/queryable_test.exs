defmodule QueryableTest do
  use ExUnit.Case
  use DbTest

  test "find inserted objects using single criteria" do
    insert([%Sample{name: "foo", age: 18}, %Sample{name: "foo", age: 17}])

    assert [under: 19] |> Sample.query() |> Repo.all() |> length() == 2
    assert [under: 18] |> Sample.query() |> Repo.all() |> length() == 1
    assert [under: 17] |> Sample.query() |> Repo.all() |> length() == 0
  end

  test "find inserted objects using default criteria (schema fields)" do
    insert([%Sample{name: "foo", surname: "bar"}])

    assert [name: "foo"] |> Sample.query() |> Repo.all() |> length() == 1
    assert [surname: "bar"] |> Sample.query() |> Repo.all() |> length() == 1
    assert [age: nil] |> Sample.query() |> Repo.all() |> length() == 1
  end

  test "find inserted objects using multiple criteria" do
    insert([%Sample{name: "foo", surname: "bar", age: 17}])

    assert [name: "foo", under: 18] |> Sample.query() |> Repo.all() |> length() == 1
    assert [name: "invalid", under: 18] |> Sample.query() |> Repo.all() |> length() == 0
  end

  test "find inserted objects and sorting them" do
    insert([%Sample{name: "foo", surname: "baz"}, %Sample{name: "foo", surname: "bar"}])

    [first, second] = [name: "foo", ordered_by: :surname] |> Sample.query() |> Repo.all()

    assert first.surname == "bar"
    assert second.surname == "baz"
  end
end
