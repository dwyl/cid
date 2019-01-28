defmodule DwylCidTest do
  use ExUnit.Case
  doctest DwylCid

  test "Creates a deterministic Content ID from Elixir String" do
    assert DwylCid.make("Elixir") == "NSqJspBr2u1F6z1DhcR2cnQAxLdQZBLk"
  end

  test "Create a CID from a Map" do
    map = %{cat: "Meow", dog: "Woof", fox: "What Does The Fox Say?"}
    assert DwylCid.make(map) == "GdrVnsLSdxRphXgQgNsmq1FDyRXAySXT"
  end

  test "DwylCid.make(\"hello world\")" do
    assert DwylCid.make("hello world") == "MJ7MSJwS1utMxA9QyQLytNDtd5RGnx6m"
  end

  test "DwylCid.cid returns the same CID as IPFS when given a string" do
    {:ok, cid} = DwylCid.cid("Hello World")
    assert cid == "zb2rhkpbfTBtUV1ESqSScrUre8Hh77fhCKDLmX21rCo5xp8J9"
  end

  test "DwylCid.cid returns the same CID as IPFS when given a map" do
    {:ok, cid} = DwylCid.cid(%{a: "a"})
    assert cid == "zb2rhbYzyUJP6euwn89vAstfgG2Au9BSwkFGUJkbujWztZWjZ"
  end

  test "DwylCid.cid returns the same CID as IPFS when given a struct" do
    {:ok, cid} = DwylCid.cid(%DwylCid{a: "a"})
    assert cid == "zb2rhbYzyUJP6euwn89vAstfgG2Au9BSwkFGUJkbujWztZWjZ"
  end
end
