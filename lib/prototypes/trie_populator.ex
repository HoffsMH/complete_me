defmodule TriePopulator do
  @ti TrieInserter

  def populate(words \\ "")

  def populate(words) do
    words
    |> Words.to_list()
    |> Enum.reduce(new_trie(), &@ti.insert(&2, &1))
  end

  defp new_trie, do: @ti.insert()
end
