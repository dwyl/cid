defmodule Cid do
  @moduledoc """
  Provides a way for a user to turn a String, Map or Struct into a CID that
  is identical to one that will be returned from IPFS if the same data is
  added.

  Currently only produces a default v1 CID.
  Currently only uses the "raw" codec
  Data provided must be under 256Kb in order for the CID to match the one
  returned by IPFS

  For more info on CIDs and IPFS see the following...
  https://ipfs.io/
  https://pascalprecht.github.io/posts/content-identifiers-in-ipfs/
  https://github.com/dwyl/learn-ipfs/issues
  """

  @doc """
  `cid/1` Returns a Content ID (CID)
  identical to the `cid` returned by `IPFS` for the same input data.if given the same data.
  accepts a String, Map or Struct as an argument.

  ## Examples

      iex> Application.put_env(:excid, :base, :base32)
      iex> Cid.cid("hello")
      "bafkreibm6jg3ux5qumhcn2b3flc3tyu6dmlb4xa7u5bf44yegnrjhc4yeq"

      iex> Application.put_env(:excid, :base, :base58)
      iex> Cid.cid("hello")
      "zb2rhZfjRh2FHHB2RkHVEvL2vJnCTcu7kwRqgVsf9gpkLgteo"

      iex> Application.put_env(:excid, :base, :base32)
      iex> Cid.cid(%{key: "value"})
      "bafkreihehk6pgn2sisbzyajpsyz7swdc2izkswya2w6hgsftbgfz73l7gi"

      iex> Application.put_env(:excid, :base, :base58)
      iex> Cid.cid(%{key: "value"})
      "zb2rhn1C6ZDoX6rdgiqkqsaeK7RPKTBgEi8scchkf3xdsi8Bj"

      iex> Cid.cid(1234)
      "invalid data type"

      iex> Cid.cid([1,2,3,"four"])
      "invalid data type"

      iex> Application.put_env(:excid, :base, :wrong_base)
      iex> Cid.cid("hello")
      "invalid base"
  """
  @spec cid(String.t | map() | struct()) :: String.t
  def cid(value) do
    value
    |> create_multihash()
    |> create_cid()
  end

  # create_multihash returns a multihash. A multihash is a self describing hash.
  # for more info on multihashes see this blog post...
  # https://pascalprecht.github.io/posts/future-proofed-hashes-with-multihash/
  # if create_multihash is called with a struct, the struct is converted into a
  # map and then create_multihash is called again
  # The %_{} syntax works like regular pattern matching. The underscore, _,
  # simply matches any Struct/Module name.
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

  # if create_multihash is called with a string then the string is converted
  # into a multihash. This uses the erlang crypto hash function. For more
  # infomation on using # erlang functions in elixir see...
  # https://stackoverflow.com/questions/35283888/how-to-call-an-erlang-function-in-elixir
  defp create_multihash(str) when is_binary(str) do
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
  # Base58Encode.encode58 or Base.encode32 takes the binary returned from create_cid_suffix and converts
  # it into the specified base string.
  # For more info on base58 strings see https://en.wikipedia.org/wiki/Base58
  defp create_cid(multihash) when is_binary(multihash) do
    base = Application.get_env(:excid, :base) || :base32
    hash = multihash
    |> create_cid_suffix()
    |> encode_with_base(base)

    case hash do
      {:ok, h} -> add_multibase_prefix(h, base)
      {:error, e} -> e
    end
  end

  # takes a multihash and returns the suffix
  # currently version is hardcoded to 1
  # (currenly IPFS only have 2 versions, 0 or 1. O is deprecated)
  # and multicodec-packed-content-type is hardcoded to "raw" ("U" == <<85>>)
  # more info on multicodec can be found https://github.com/multiformats/multicodec
  # <version><multicodec-packed-content-type><multihash>
  # the syntax on this line is concatenating strings and binary values together.
  # Strings in elixir are binaries and that is how this works. Learn more here...
  # https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html
  defp create_cid_suffix(multihash), do: <<1>> <> "U" <> multihash

  # Takes a binary, a base and return the encoded binary in the base.
  defp encode_with_base(binary, base) do
    case base do
      :base58 -> {:ok, Base58.encode(binary)}

      :base32 -> {:ok, Base.encode32(binary, case: :lower, padding: false)}

      _ -> {:error, "invalid base"}

    end
  end

  # adds the multibase prefix (multibase-prefix) to the suffix (<version><mc><mh>)
  # for more info on multibase, see https://github.com/multiformats/multibase
  defp add_multibase_prefix(suffix, :base58), do: "z" <> suffix
  defp add_multibase_prefix(suffix, :base32), do: "b" <> suffix

end
