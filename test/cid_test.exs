defmodule DummyStruct do
  defstruct [:name, :username, :age]
end

defmodule CidTest do
  use ExUnit.Case
  use ExUnitProperties

  doctest Cid

  defstruct [:a]
  @filename "random.txt"
  @ipfs_args ["add", @filename, "-n", "--cid-version=1"]
  @dummy_map %{
    name: "Batman",
    username: "The Batman",
    age: 80
  }

  describe "Testing Cid cid function" do
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
      struct = %DummyStruct{
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

    # Property based tests that generate random strings and
    # use them in our compare_ipfs_cid function
    # Tagged to allow you to ignore these tests if you don't have ipfs installed
    @tag :ipfs
    property "test with 50 random strings" do
      check all str <- StreamData.string(:ascii), max_runs: 50 do
        compare_ipfs_cid(str)
      end
    end

    # Property based tests that generate random maps and
    # use them in our compare_ipfs_cid function
    # Tagged to allow you to ignore these tests if you don't have ipfs installed
    @tag :ipfs
    property "test with 50 random maps" do
      check all map <- random_map(), max_runs: 50 do
        map
        |> Jason.encode!()
        |> compare_ipfs_cid()
      end
    end
  end

  # Calls IPFS `add` function to generate cid
  # then compares result to result of our `Cid.cid` function
  # see: https://docs.ipfs.io/introduction/usage/
  def compare_ipfs_cid(val) do
    File.write(@filename, val)

    {added_val, 0} = System.cmd("ipfs", @ipfs_args)

    <<"added ", cid::bytes-size(49), _::binary>> = added_val

    assert cid == Cid.cid(val)

    File.rm!(@filename)
  end

  def random_map do
    keys = StreamData.atom(:alphanumeric)
    values = StreamData.one_of([random_value(), StreamData.list_of(random_value())])

    StreamData.map_of(keys, values)
  end

  def random_value do
    StreamData.one_of([StreamData.string(:ascii), StreamData.integer()])
  end
end
