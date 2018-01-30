defmodule TriePopulator do
  @ti TrieInserter

  def populate(words \\ "")

  def populate(trie, ""), do: trie
  def populate(words) when is_binary(words) do 
    populate(@ti.insert(), words)
  end
  def populate(word_list) when is_list(word_list) do
   populate(@ti.insert(), word_list)
 end

  def populate(trie, word_list) when is_list(word_list) do
    word_list
    |> Enum.reduce(trie, &@ti.insert(&2, &1))
  end

  def populate(trie, words_text) when is_binary(words_text) do
    populate(trie, String.split(words_text, "\n"))
  end
end
