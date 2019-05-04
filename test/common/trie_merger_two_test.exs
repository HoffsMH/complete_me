defmodule TrieMergerTwoTest do
  use ExUnit.Case, async: true
  @tm TrieMergerTwo

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

  test "merge with a double trie reversed" do
    trie_one = %{
      e: %{a: %{value: "ea"}},
      a: %{f: %{value: "af"}, b: %{d: %{value: "abd"}}}
    }

    trie_two = %{
      d: %{value: "d"},
      a: %{b: %{value: "ab"}}
    }

    expected = %{
      d: %{value: "d"},
      e: %{a: %{value: "ea"}},
      a: %{f: %{value: "af"}, b: %{value: "ab", d: %{value: "abd"}}}
    }

    assert @tm.merge(trie_one, trie_two) === expected
  end
end
