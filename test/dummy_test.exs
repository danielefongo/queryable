defmodule Queryable.DummyTest do
  use ExUnit.Case
  use DbTest

  test "integrates with db" do
    Repo.insert(%Sample{name: "foo"})

    [retrieved_sample | _] = Repo.all(Sample)

    assert retrieved_sample.name == "foo"
  end
end
