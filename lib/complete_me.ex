defmodule CompleteMe do
  @ti TrieInserter

  def count(model \\ %{})

  def count(%{words: words})
      when is_list(words) do
    length(words)
  end

  def count(%{}), do: 0

  def insert do
    createModel(@ti.insert(), [])
  end

  def insert(word) when is_binary(word) do
    createModel(@ti.insert(word), [word])
  end

  def insert(%{trie: trie, words: words}, word) do
    createModel(@ti.insert(trie, word), [word | words])
  end

  defp createModel(trie, words) do
    %{trie: trie, words: words}
  end
end
