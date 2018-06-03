defmodule TriePopulatorEight do
  @ti TrieInserter
  @tm TrieMerger

  def populate(words \\ "")

  def populate(words) do
    word_list = Words.to_list(words)
    word_portions = split_list(word_list, 24)

    tries =
      word_portions
      |> Parallel.map(&form_trie_from_word_list/1)

    [first_trie | rest] = tries

    rest
    |> Enum.reduce(first_trie, &@tm.merge(&2, &1))
  end

  def form_trie_from_word_list(word_list) do
    word_list
    |> Enum.reduce(new_trie(), &@ti.insert(&2, &1))
  end

  defp new_trie, do: @ti.insert()

  def split_list(list, num_of_portions) do
    hi(list, portion_size(list, num_of_portions))
  end

  def hi(list \\ [], portion_size)

  def hi(list, portion_size),
    do: hi(list, portion_size, [])

  defp hi([], _, result), do: result

  defp hi(list, portion_size, accum) do
    {new_portion, rest} = Enum.split(list, portion_size)
    hi(rest, portion_size, [new_portion | accum])
  end

  def portion_size(list, num_of_portions) do
    round(length(list) / num_of_portions)
  end
end
