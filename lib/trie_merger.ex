defmodule TrieMerger do
  @ti TrieInserter

  def merge(), do: new_trie()
  def merge(single_trie), do: single_trie

  def merge(nil, trie), do: trie

  def merge(trie_one, trie_two) do
    trie_two
    |> Enum.reduce(trie_one, &merge_keys/2)
  end

  defp merge_keys({key, value}, trie_one) do
    # trying to make it more clear what is happening
    with sub_trie_one <- trie_one[key],
         sub_trie_two <- value,
         new_sub_trie <- merge(sub_trie_one, sub_trie_two) do
      Map.put(trie_one, key, new_sub_trie)
    end
  end

  defp new_trie, do: @ti.insert()
end
