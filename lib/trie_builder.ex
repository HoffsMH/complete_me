defmodule TrieBuilder do
  def insert(word \\ "")
  def insert(word) do
    String.graphemes
  end

  defp new_trie(), do: %{}
end
