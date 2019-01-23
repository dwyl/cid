defmodule Cid do
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

  def encodeCid(data) do
    # CIDv1 is multibase - cid version - multicontent - multihash
    # with base58btc - version 1 - protobuf - multihash (ie CIDv0)

    # define all these value in hex, then concat them then encode with base58btc to get the cid

    # table value is 0xz ie 57 in decimal (the last value of the charecter set in base58)
    # see https://github.com/multiformats/multibase/blob/master/multibase.csv
    base58btc = Integer.to_string(57, 16)
    # 0 or 1
    version1 = Integer.to_string(1, 16)
    # protobuf is 0x50 in table https://github.com/multiformats/multicodec/blob/master/table.csv
    protobuf = Integer.to_string(83,16)

    multihash = get_multihash(data)

    base58btc <> version1 <> protobuf <> multihash
  end

  def get_multihash(data) do
    data
    |> hash()
    |> multihash()
    |> encode()
  end



  def hash(data), do: :crypto.hash(:sha256, data)

  def multihash(digest), do: Multihash.encode(:sha2_256, digest)

  def encode({:ok, multihash}), do: Base.encode16(multihash, case: :lower)

end
