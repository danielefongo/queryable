defmodule QueryableTest do
  use ExUnit.Case
  use DbTest

  test "find inserted object using single criteria" do
    insert([%Sample{name: "foo", surname: "bar"}])

    assert [name: "foo"] |> Sample.query() |> Repo.all() |> length() == 1
    assert [surname: "bar"] |> Sample.query() |> Repo.all() |> length() == 1
    assert [surname: "not valid"] |> Sample.query() |> Repo.all() |> length() == 0
  end

  test "find inserted object using multiple criteria" do
    insert([%Sample{name: "foo", surname: "bar"}])

    assert [name: "foo", surname: "bar"] |> Sample.query() |> Repo.all() |> length() == 1
    assert [name: "foo", surname: "not valid"] |> Sample.query() |> Repo.all() |> length() == 0
  end

  test "find inserted objects and sorting them" do
    insert([%Sample{name: "foo", surname: "baz"}, %Sample{name: "foo", surname: "bar"}])

    [first, second] = [name: "foo", order_by: :surname] |> Sample.query() |> Repo.all()

    assert first.surname == "bar"
    assert second.surname == "baz"
  end
end
