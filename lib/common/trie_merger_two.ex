defmodule TrieMergerTwo do
  def merge(nil, trie), do: trie

  def merge(trie_one, trie_two) when is_map(trie_two) do
    trie_two
    |> Enum.map(&Task.async(fn -> merge_keys(&1, trie_one) end))
    |> Enum.map(&Task.await/1)
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  def merge(trie_one, trie_two)
      when trie_one == trie_two,
      do: trie_one

  defp merge_keys({key, value}, trie_one) do
    # trying to make it more clear what is happening
    with sub_trie_one <- trie_one[key],
         sub_trie_two <- value,
         new_sub_trie <- merge(sub_trie_one, sub_trie_two) do
      Map.put(trie_one, key, new_sub_trie)
    end
  end
end
