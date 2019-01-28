defmodule Cid do
  @moduledoc """
  Provides a way for a user to turn a String, Map or Struct into a CID that
  is identical to one what will be returned from IPFS if the same data is
  added.

  Currently only produces a default v1 CID.
  Currently only uses the "raw" codec
  Data provided must be under 256Kb in order for the CID to match the one
  returned by IPFS
  """

  @doc """
  Returns a CID that identical to one returned by IPFS if given the same data.
  Can take a String, Map or Struct as an argument.

  ## Examples

    iex> Cid.cid("hello")
    "zb2rhcc1wJn2GHDLT2YkmPq5b69cXc2xfRZZmyufbjFUfBkxr"

    iex> Cid.cid(%{key: "value"})
    "zb2rhkN6szWhAmBFjjP8RSczv2YVNLnG1tz1Q7FyfEp8LssNZ"
  """
  def cid(value) do
    value
    |> create_multihash()
    |> create_cid()
  end

  # if create_multihash is called with a struct, the struct is converted into a
  # map and then create_multihash is called again
  defp create_multihash(%_{} = struct) do
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
  defp create_multihash(_), do: {:error, "invalid data type"}

  # if an error is passed in return error message
  defp create_cid({:error, msg}), do: msg

  # takes a multihash and retuns a CID
  defp create_cid(multihash) when is_binary(multihash) do
    multihash
    |> create_cid_suffix()
    |> B58.encode58()
    |> add_multibase_prefix()
  end

  # takes a multihash and returns the suffix
  # currently version is hardcoded to 1
  # and multicodec-packed-content-type is hardcoded to "raw" ("U" == <<85>>)
  # <version><multicodec-packed-content-type><multihash>
  defp create_cid_suffix(multihash), do: <<1>> <> "U" <> multihash

  # adds the multibase prefix to the suffix (<version><mc><mh>)
  defp add_multibase_prefix(suffix), do: "z" <> suffix

  # adds new line to the end of string. (exists because all tests with ipfs
  # appeared to do the same thing.)
  defp add_new_line(str) do
    str <> "\n"
  end
end
