defmodule TriePopulator do
  @default_portions 7
  @default_max_portion_size 1000

  def populate(
        words \\ "",
        portions \\ @default_portions,
        max_portion_size \\ @default_max_portion_size
      )

  def populate("", _portions, _portion_max), do: %{}

  def populate(words_text, portions, max_portion_size) when is_binary(words_text) do
    String.split(words_text, "\n")
    |> populate(portions, max_portion_size)
  end

  def populate(word_list, portions, max_portion_size) when is_list(word_list) do
    with starting_portion_size <- determine_portion_size(word_list, portions),
         portion_size <- min(starting_portion_size, max_portion_size) do
      word_list
      |> Enum.reject(&(&1 == ""))
      |> Enum.chunk_every(portion_size)
      |> Enum.map(&build_trie_job/1)
      |> Enum.map(&Task.await/1)
      |> merge_tries()
    end
  end

  def build_trie(word_list) do
    word_list
    |> Enum.reduce(%{}, &TrieInserter.insert(&2, &1))
  end

  def build_trie_job(word_list) do
    Task.async(fn ->
      build_trie(word_list)
    end)
  end

  def merge_tries(trie_list) do
    trie_list
    |> Enum.reduce(%{}, &TrieMerger.merge(&1, &2))
  end

  def determine_portion_size(word_list, portions) do
    round(Float.ceil(length(word_list) / portions))
  end
end
