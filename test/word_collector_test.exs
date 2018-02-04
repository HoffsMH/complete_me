defmodule WordCollectorTest do
  use ExUnit.Case, async: true
  @wc WordCollector

  test "collect with nothing" do
    assert @wc.collect() === []
  end

  test "collect with empty trie" do
    assert @wc.collect(%{}) === []
  end

  test "collect with just a model and no string" do
    trie = %{
      a: %{value: "a"},
      b: %{a: %{t: %{value: "bat"}}, value: "b"}
    }

    assert @wc.collect(trie) === ["a", "b", "bat"]
  end

  test "collect with more complicated model" do
    model = CompleteMe.populate(["a", "bat", "ba", "batter"])

    assert @wc.collect(model[:trie]) === ["a", "ba", "bat", "batter"]
  end

  test "collect with more complicated model and nothing to collect" do
    model = CompleteMe.populate()

    assert @wc.collect(model[:trie]) === []
  end

end
