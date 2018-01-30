defmodule Words do
  def to_list(word_list \\ "")
  def to_list(""), do: []

  def to_list(word_list)
      when is_list(word_list),
      do: word_list

  def to_list(word_text) when is_binary(word_text) do
    String.split(word_text, "\n")
    |> Enum.uniq()
    |> Enum.sort()
  end

  def to_list(words_one, words_two) do
    with word_list_one <- Words.to_list(words_one),
         word_list_two <- Words.to_list(words_two) do
      word_list_one
      |> Enum.concat(word_list_two)
      |> Enum.uniq()
      |> Enum.sort()
    end
  end
end
