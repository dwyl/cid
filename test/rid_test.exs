defmodule RidTest do
  use ExUnit.Case
  doctest Rid

  test "greets the world" do
    assert Rid.hello() == :world
  end
end
