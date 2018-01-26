defmodule TrieInserter do
  def insert(word \\ "")

  def insert(word) do
    insert(%{}, word)
  end

  def insert(trie, ""), do: trie

  def insert(trie, word) when is_binary(word) do
    insert(trie, atom_list(word), word)
  end

  def insert(nil, graphemeList, word) do
    insert(%{}, graphemeList, word)
  end

  def insert(trie, [], word) do
    Map.put(trie, :value, word)
  end

  def insert(trie, graphemeList, word) do
    [first_letter | remaining_letters] = graphemeList
    sub_trie = trie[first_letter]

    Map.put(trie, first_letter, insert(sub_trie, remaining_letters, word))
  end

  defp atom_list(word) do
    word
    |> String.graphemes()
    |> Enum.map(&String.to_atom/1)
  end
end
