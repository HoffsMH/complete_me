defmodule Words do
  def to_word_list(word_list \\ "")
  def to_word_list(""), do: []
  def to_word_list(word_text) when is_binary(word_text) do
    String.split(word_text, "\n")
  end
  def to_word_list(word_list) when is_list(word_list) do
    word_list
  end

  def to_word_list(word_list_one, word_list_two) do
    Enum.uniq(to_word_list(word_list_one) ++ to_word_list(word_list_two))
  end
end
