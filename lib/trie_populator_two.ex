defmodule TriePopulatorTwo do
  @ti TrieInserter
  def populate(words \\ "")

  def populate(word_list) when is_list(word_list) do
    word_list
    |> Enum.reduce(@ti.insert(), &(@ti.insert(&2,&1)))
  end

  def populate(words_text) when is_binary(words_text) do
    String.split(words_text, "\n")
    |> populate
  end
end
