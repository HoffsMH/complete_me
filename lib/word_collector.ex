defmodule WordCollector do
  def collect(), do: []

  def collect(trie) do
    collect(trie, -1)
    |> sort
  end

  defp collect({:value, word}, depth) do
    %{word: word, depth: depth}
  end

  defp collect({_, value}, depth) do
    collect(value, depth + 1)
    |> List.flatten()
  end

  defp collect(trie, depth) do
    trie
    |> Enum.map(&collect(&1, depth))
    |> List.flatten()
  end

  defp sort(words) do
    words
    |> Enum.sort_by(&depth/1)
    |> Enum.map(&word/1)
  end

  defp depth(%{depth: depth}), do: depth
  defp word(%{word: word}), do: word
end
