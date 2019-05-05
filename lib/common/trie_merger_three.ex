defmodule TrieMergerThree do
  def merge(nil, trie), do: trie

  def merge(trie_one, trie_two) when is_map(trie_two) do
    DeepMerge.deep_merge(trie_one, trie_two)
  end
end
