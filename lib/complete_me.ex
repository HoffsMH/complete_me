defmodule CompleteMe do
  @ti TrieInserter
  @tp TriePopulator

  def count, do: 0
  def insert, do: create_model()
  def populate(), do: create_model()

  def count(%{words: words})
      when is_list(words),
      do: length(words)

  def insert(word) do
    create_model(@ti.insert(word), [word])
  end

  def insert(%{trie: trie, words: words}, word) do
    create_model(@ti.insert(trie, word), Words.to_list(words, word))
  end

  def populate(word_text) do
    create_model(@tp.populate(word_text), Words.to_list(word_text))
  end

  defp create_model(trie, words) do
    %{trie: trie, words: words}
  end

  defp create_model do
    %{trie: %{}, words: []}
  end
end
