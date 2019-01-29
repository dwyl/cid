defmodule DummyStruct do
  defstruct [:name, :username, :age]
end

defmodule CidTest do
  use ExUnit.Case
  use ExUnitProperties

  doctest Cid

  defstruct [:a]
  @filename "random_str.txt"
  @ipfs_args ["add", "random_str.txt", "-n", "--cid-version=1"]
  @dummy_map %{
    name: "Batman",
    username: "The Batman",
    age: 80
  }

  describe "Testing ex_cid cid function" do
    test "returns the same CID as IPFS when given a string" do
      assert "zb2rhhnbH6zTaAj948YVsYxW4c5AY6TfJURC9EGhQum3Kq7b3" == Cid.cid("Hello World")
    end

    test "returns the same CID as IPFS when given a map" do
      assert "zb2rhdeaHh2UHghBcwxeFP1GRUYETDH96DkV6oppiz5Gk1xGN" == Cid.cid(%{a: "a"})
    end

    test "returns the same CID as IPFS when given a struct" do
      assert "zb2rhdeaHh2UHghBcwxeFP1GRUYETDH96DkV6oppiz5Gk1xGN" == Cid.cid(%__MODULE__{a: "a"})
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
      refute Cid.cid("") == Cid.cid(" ")
      refute Cid.cid("\n") == Cid.cid("")
      refute Cid.cid("Hello World") == Cid.cid("salve mundi")
      refute Cid.cid("Hello World") == Cid.cid("hello world")
      refute Cid.cid(%{a: "a"}) == Cid.cid(%{a: "b"})
      refute Cid.cid(%__MODULE__{a: "a"}) == Cid.cid(%DummyStruct{})
    end

    test "empty values also work" do
      assert Cid.cid("") == "zb2rhmy65F3REf8SZp7De11gxtECBGgUKaLdiDj7MCGCHxbDW"
      assert Cid.cid(%{}) == "zb2rhbE2775XANjTsRTV9sxfFMWxrGuMWYgshDn9xvjG69fZ3"
    end

    @tag :ipfs
    property "test with 100 random strings" do
      check all str <- StreamData.string(:ascii) do

        File.write(@filename, str)

        {added_str, 0} = System.cmd("ipfs", @ipfs_args)

        <<"added ", cid::bytes-size(49), _::binary>> = added_str

        assert cid == Cid.cid(str)
        
        File.rm!(@filename)
      end
    end
  end
end
