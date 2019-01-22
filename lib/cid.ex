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

  # check for cid v0. It needs to be a binary ie a string with length 46
  def decode(cid) when is_binary(cid) do
    if  String.length(cid) == 46  do # why 46? we could also use byte_size as
      case cid do
        <<"Qm", _rest :: binary >> -> {:ok, "cidv0"}
        _ -> multibase_decode(cid)
      end

    else
      multibase_decode(cid)
    end
  end

  def multibase_decode(cid) do
    # TODO cid follow v1 format, find base then get binary
    {:ok, "cidv1"}
  end

    #1 - If it's a string (ASCII/UTF-8):
    #
    # If it is 46 characters long and starts with Qm..., it's a CIDv0. Decode it as base58btc and continue to step 2.
    # Otherwise, decode it according to the multibase spec and:
    #     If the first decoded byte is 0x12, return an error. CIDv0 CIDs may not be multibase encoded and there will be no CIDv18 (0x12 = 18) to prevent ambiguity with decoded CIDv0s.
    #     Otherwise, you now have a binary CID. Continue to step 2.
    #
    #2 - Given a (binary) CID (cid):
    #     If it's 34 bytes long with the leading bytes [0x12, 0x20, ...], it's a CIDv0.
    #         The CID's multihash is cid.
    #         The CID's multicodec is DagProtobuf
    #         The CID's version is 0.
    #     Otherwise, let N be the first varint in cid. This is the CID's version.
    #         If N == 1 (CIDv1):
    #             The CID's multicodec is the second varint in cid
    #             The CID's multihash is the rest of the cid (after the second varint).
    #             The CID's version is 1.
    #         If N <= 0, the CID is malformed.
    #         If N > 1, the CID version is reserved.

end
