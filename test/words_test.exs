defmodule WordsTest do
  use ExUnit.Case, async: true
  @wl Words

  test "to_word_list with nothing" do
    assert @wl.to_word_list() === []
  end

  test "to_word_list with empty string" do
    assert @wl.to_word_list("") === []
  end

  test "to_word_list with a" do
    assert @wl.to_word_list("a") === ["a"]
  end

  test "to_word_list with a\nb" do
    assert @wl.to_word_list("a\nb") === ["a","b"]
  end

  test "to_word_list with a word list" do
    assert @wl.to_word_list(["a","b"]) === ["a","b"]
  end

  test "to_word_list with 2 arrays" do
    assert @wl.to_word_list(["a","b"], ["c","d"]) === 
    ["a","b","c","d"]
  end

  test "to_word_list with 2 arrays with some duplicates" do
    assert @wl.to_word_list(["a","b"], ["b","d"]) === 
    ["a","b","d"]
  end
end
