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

  test "Cid.make(\"hello world\")" do
    assert Cid.make("hello world") == "MJ7MSJwS1utMxA9QyQLytNDtd5RGnx6m"
  end

  test "Cid.decode cidv0 format" do
    assert Cid.decode("QmPZ9gcCEpqKTo6aq61g2nXGUhM4iCL3ewB6LDXZCtioEB") == {:ok, "cidv0"}
  end

  test "Cid.decode cidv1 format" do
    assert Cid.decode("wrongcid") == {:ok, "cidv1"}
  end

end
