defmodule DwylCid do
  defstruct [:a]
  @moduledoc """
  Returns a SHA512 transformed to Base64, remove ambiguous chars then sub-string
  """

  @doc """
  make/2 create a SHA512 hash from the given input and return the require length
  note: we remove "ambiguous" characters so _humans_ can type the hash without
  getting "confused" this might not be required, but is to match the original
  "Hits" implementation.

  ## Parameters

  - input: String the string to be hashed.
  - length: Number the length of string required

  Returns String hash of desired length.
  """
  def make(input) when is_map(input) do
    input |> stringify_map_values |> make
  end

  def make(input, length \\ 32) do
    hash1 = :crypto.hash(:sha512, input)
    {:ok, <<_multihash_code, _length, hash2::binary>>} = Multihash.encode(:sha2_512, hash1)

    hash2
    |> Base.encode64()
    |> String.replace(~r/[Il0oO=\/\+]/, "", global: true)
    |> String.slice(0..(length - 1))
  end

  def stringify_map_values(input_map) do
    Enum.sort(Map.keys(input_map)) # sort map keys for consistent ordering
    |> Enum.map(fn (x) -> Map.get(input_map, x) end)
    |> Enum.join("")
  end

  def cid(value) do
    value
    |> create_multihash()
    |> create_cid()
  end

  # if create_multihash is called with a struct, the struct is converted into a
  # map and then create_multihash is called again
  defp create_multihash(%__MODULE__{} = struct) do
    struct
    |> Map.from_struct()
    |> create_multihash()
  end

  # if create_multihash is called with a map the map is converted into a JSON
  # string and then create_multihash is called again
  defp create_multihash(map) when is_map(map) do
    map
    |> Jason.encode!()
    |> create_multihash()
  end

  # if create_multihash is called with a string, the string has a new line added
  # to the end (as that's what IPFS appears to be doing based on tests), then
  # the string is converted into a multihash
  defp create_multihash(str) when is_binary(str) do
    str = add_new_line(str)
    digest = :crypto.hash(:sha256, str)
    {:ok, multihash} = Multihash.encode(:sha2_256, digest)

    multihash
  end

  # if create_multihash is called something that is not a string, map or struct
  # then it returns an error.
  defp create_multihash(_), do: {:error, "incorrect type"}

  defp create_cid({:error, msg}), do: msg

  defp create_cid(multihash) when is_binary(multihash) do
    multihash
    |> CID.cid!("raw", 1)
    |> CID.encode()
  end

  defp add_new_line(str) do
    str <> "\n"
  end
end
