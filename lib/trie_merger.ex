defmodule TrieMerger do
  @ti TrieInserter
  def merge(), do: %{}
  def merge(single_trie), do: single_trie

  def merge(nil, trie), do: trie

  def merge(trie_one, trie_two) do
    trie_two
    |> Enum.reduce(trie_one, &merge_keys/2)
  end

  defp merge_keys({key, value}, trie_one) do
    Map.put(trie_one, key, merge(trie_one[key], value))
  end
end
