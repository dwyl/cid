defmodule CidTest do
  use ExUnit.Case
  doctest Cid

  test "Creates a deterministic Content ID from Elixir String" do
    assert Cid.make("Elixir") == "NSqJspBr2u1F6z1DhcR2cnQAxLdQZBLk"
  end

  test "Create a CID from a Map" do
    map = %{cat: "Meow", dog: "Woof", fox: "What Does The Fox Say?"}
    assert Cid.make(map) == "GdrVnsLSdxRphXgQgNsmq1FDyRXAySXT"
  end

end
