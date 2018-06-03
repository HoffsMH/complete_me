defmodule TriePopulatorFive do
  @ti TrieInserter
  @tm TrieMerger

  def populate(words \\ "")

  def populate(words) do
    word_list = Words.to_list(words)
    {first_half, second_half} = split_in_half(word_list)

    first_trie_task = Task.async(__MODULE__, :form_trie_from_word_list, [first_half])
    second_trie_task = Task.async(__MODULE__, :form_trie_from_word_list, [second_half])

    first_trie = Task.await(first_trie_task)
    second_trie = Task.await(second_trie_task)

    @tm.merge(first_trie, second_trie)
  end

  def split_in_half(word_list) do
    Enum.split(word_list, middle_index(word_list))
  end

  def middle_index(word_list) do
    round(length(word_list) / 2)
  end

  def form_trie_from_word_list(word_list) do
    word_list
    |> Enum.reduce(new_trie(), &@ti.insert(&2, &1))
  end

  defp new_trie, do: @ti.insert()
end
