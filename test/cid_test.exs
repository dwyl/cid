defmodule CidTest do
  use ExUnit.Case
  doctest Cid

  defstruct [:a]

  describe "Testing ex_cid function" do

    test "ExCid.cid returns the same CID as IPFS when given a string" do
      assert "zb2rhkpbfTBtUV1ESqSScrUre8Hh77fhCKDLmX21rCo5xp8J9" == Cid.cid("Hello World")
    end

    test "ExCid.cid returns the same CID as IPFS when given a map" do
      assert "zb2rhbYzyUJP6euwn89vAstfgG2Au9BSwkFGUJkbujWztZWjZ" == Cid.cid(%{a: "a"})
    end

    test "ExCid.cid returns the same CID as IPFS when given a struct" do
      assert "zb2rhbYzyUJP6euwn89vAstfgG2Au9BSwkFGUJkbujWztZWjZ" == Cid.cid(%__MODULE__{a: "a"})
    end

    test "DwylCid.cid returns an error if given invalid data type" do
      assert Cid.cid(2) == "invalid data type"
    end
  end
end
