defmodule TriePopulatorTwo do
  @ti TrieInserter
  @tm TrieMerger

  def populate(words \\ "")

  def populate(word_list) when is_list(word_list) do
    word_list
    |> pmap(&@ti.insert/1)
    |> Enum.reduce(%{},&@tm.merge/2)
  end

  def populate(words_text) when is_binary(words_text) do
    String.split(words_text, "\n")
    |> populate
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end
