defmodule TrieSuggestion do
  @wc WordCollector

  def suggest, do: []
  def suggest(_), do: []

  def suggest(trie, word) do
    all_sub_words(trie, word)
    |> Enum.filter(&(word !== &1))
  end

  defp all_sub_words(trie, "") do
    @wc.collect(trie)
  end

  defp all_sub_words(trie, sub_word) do
    with new_args <- get_sub_trie(trie, sub_word),
         {sub_trie, rest_of_word} <- new_args do
      all_sub_words(sub_trie, rest_of_word)
    end
  end

  defp get_sub_trie(trie, word) do
    import String
    import Enum

    with [first_char | rest] <- graphemes(word),
         rest <- join(rest),
         key <- to_atom(first_char),
         sub_trie <- trie[key] do
      {sub_trie, rest}
    end
  end
end
