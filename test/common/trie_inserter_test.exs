defmodule TrieInserterTest do
  use ExUnit.Case, async: true
  def equal(a, b), do: a === b
  @ti TrieInserter

  test "insert with nothing" do
    assert @ti.insert() === %{}
  end

  test "insert with a simple word" do
    assert @ti.insert("") === %{}
  end

  test "insert with a" do
    expected = %{a: %{value: "a"}}

    assert @ti.insert("a") === expected
  end

  test "insert with ab" do
    expected = %{a: %{b: %{value: "ab"}}}

    assert @ti.insert("ab") === expected
  end

  test "insert with ab and ac" do
    expected = %{
      a: %{c: %{value: "ac"}, b: %{value: "ab"}}
    }

    result =
      @ti.insert("ab")
      |> @ti.insert("ac")

    assert result === expected
  end

  test "insert with ab ac ba bz fi" do
    expected = %{
      a: %{b: %{value: "ab"}, c: %{value: "ac"}},
      b: %{a: %{value: "ba"}, z: %{value: "bz"}},
      f: %{i: %{value: "fi"}}
    }

    result =
      @ti.insert("ab")
      |> @ti.insert("ac")
      |> @ti.insert("ba")
      |> @ti.insert("bz")
      |> @ti.insert("fi")

    assert result === expected
  end

  test "insert with medium word list" do
    with {:ok, medium_text} <- medium_word_list(),
         word_list <- String.split(medium_text, "\n") do
      trie =
        word_list
        |> Enum.reduce(@ti.insert(), &@ti.insert(&2, &1))

      result = trie[:v][:e][:t][:u][:s][:t][:value]

      assert result === "vetust"

      result = trie[:f][:a][:s][:t][:h][:o][:l][:d][:value]

      assert result === "fasthold"
    end
  end

  def medium_word_list do
    File.read("./test/medium.txt")
  end
end
