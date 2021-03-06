defmodule QueryableTest do
  use ExUnit.Case
  use DbTest

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
    assert [_] = find(age: nil)
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
