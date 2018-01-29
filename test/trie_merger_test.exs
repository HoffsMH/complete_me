defmodule TrieMergerTest do
  use ExUnit.Case, async: true
  @tm TrieMerger

  test "merge with nothing" do
    assert @tm.merge() === %{}
  end

  test "merge with a single trie" do
    trie = %{specific: %{value: "trie"}}
    assert @tm.merge(trie) === trie
  end

  test "merge with a simple double trie" do
    trie_one = %{a: "a"}
    trie_two = %{b: "b"}

    assert @tm.merge(trie_one, trie_two) === %{a: "a", b: "b"}
  end

  test "merge with a double trie" do
    trie_one = %{
      d: %{value: "d"},
      a: %{b: %{value: "ab"}}
    }

    trie_two = %{
      e: %{a: %{value: "ea"}},
      a: %{f: %{value: "af"}, b: %{d: %{value: "abd"}}}
    }

    expected = %{
      d: %{value: "d"},
      e: %{a: %{value: "ea"}},
      a: %{f: %{value: "af"}, b: %{value: "ab", d: %{value: "abd"}}}
    }

    assert @tm.merge(trie_one, trie_two) === expected
  end
end
