defmodule CidTest do
  use ExUnit.Case
  doctest Cid

  test "greets the world" do
    assert Cid.make("Elixir") == "NSqJspBr2u1F6z1DhcR2cnQAxLdQZBLk"
  end
end
