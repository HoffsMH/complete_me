defmodule TrieSuggestionTest do
  use ExUnit.Case, async: true
  @ts TrieSuggestion

  test "suggest with nothing" do
    assert @ts.suggest() === []
  end

  test "suggest with empty string" do
    assert @ts.suggest("") === []
  end

  test "suggest when given a model and nothing else" do
    trie = %{a: %{value: "a"}, b: %{value: "b"}}
    assert @ts.suggest(trie) === []
  end

  test "suggest when given a string but no model" do
    assert @ts.suggest("hi") === []
  end

  test "suggest when given a string AND a model" do
    trie = %{a: %{value: "a"}, b: %{a: %{t: %{value: "bat"}}, value: "b"}}
    assert @ts.suggest(trie, "b") === ["bat"]
  end
end
