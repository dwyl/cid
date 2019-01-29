defmodule DummyStruct do
  defstruct [:name, :username, :age]
end

defmodule CidTest do
  use ExUnit.Case
  doctest Cid

  defstruct [:a]

  @dummy_map %{
    name: "Batman",
    username: "The Batman",
    age: 80
  }

  describe "Testing ex_cid cid function" do
    test "returns the same CID as IPFS when given a string" do
      assert "zb2rhkpbfTBtUV1ESqSScrUre8Hh77fhCKDLmX21rCo5xp8J9" == Cid.cid("Hello World")
    end

    test "returns the same CID as IPFS when given a map" do
      assert "zb2rhbYzyUJP6euwn89vAstfgG2Au9BSwkFGUJkbujWztZWjZ" == Cid.cid(%{a: "a"})
    end

    test "returns the same CID as IPFS when given a struct" do
      assert "zb2rhbYzyUJP6euwn89vAstfgG2Au9BSwkFGUJkbujWztZWjZ" == Cid.cid(%__MODULE__{a: "a"})
    end

    test "returns an error if given invalid data type" do
      assert Cid.cid(2) == "invalid data type"
    end

    test "returns the same CID regardless of order of items in map" do
      map = %{
        age: 80,
        name: "Batman",
        username: "The Batman"
      }

      assert Cid.cid(@dummy_map) == Cid.cid(map)
    end

    test "A struct with the same keys and values as a map creates the same CID" do
      struct =
        %DummyStruct{
          age: 80,
          name: "Batman",
          username: "The Batman"
        }

      assert Cid.cid(struct) == Cid.cid(@dummy_map)
    end

    test "returns a different CID when the value given differs (CIDs are all unique)" do
      refute Cid.cid("Hello World") == Cid.cid("salve mundi")
      refute Cid.cid("Hello World") == Cid.cid("hello world")
      refute Cid.cid(%{a: "a"}) == Cid.cid(%{a: "b"})
      refute Cid.cid(%__MODULE__{a: "a"}) == Cid.cid(%DummyStruct{})
    end
  end
end
