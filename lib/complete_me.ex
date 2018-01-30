defmodule CompleteMe do
  @ti TrieInserter
  @tp TriePopulator

  def count(model \\ %{})

  def count(%{words: words})
      when is_list(words) do
    length(words)
  end

  def count(%{}), do: 0

  def insert do
    create_model(@ti.insert(), [])
  end

  def insert(word) when is_binary(word) do
    create_model(@ti.insert(word), [word])
  end

  def insert(%{trie: trie, words: words} = model, word) do
    unless Enum.member?(words, word) do
      create_model(@ti.insert(trie, word), [word | words])
    else
      model
    end
  end

  def populate(), do: create_model(@tp.populate(), [])

  def populate(text) when is_binary(text) do
    create_model(@tp.populate(text), [])
  end

  def populate(%{trie: trie, words: words}, text) do
    create_model(
      @tp.populate(trie, String.split(text, "\n")),
      Enum.concat(String.split(text, "\n"), words)
    )
  end

  defp create_model(trie, words) do
    %{trie: trie, words: words}
  end
end
