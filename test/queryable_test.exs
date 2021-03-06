defmodule QueryableTest do
  use ExUnit.Case
  use DbTest

  test "find inserted object using single criteria" do
    insert([%Sample{name: "foo", surname: "bar"}])

    assert [name: "foo"] |> Sample.where() |> Repo.all() |> length() == 1
    assert [surname: "bar"] |> Sample.where() |> Repo.all() |> length() == 1
    assert [surname: "not valid"] |> Sample.where() |> Repo.all() |> length() == 0
  end

  test "find inserted object using multiple criteria" do
    insert([%Sample{name: "foo", surname: "bar"}])

    assert [name: "foo", surname: "bar"] |> Sample.where() |> Repo.all() |> length() == 1
    assert [name: "foo", surname: "not valid"] |> Sample.where() |> Repo.all() |> length() == 0
  end
end
