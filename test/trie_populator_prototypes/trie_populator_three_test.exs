defmodule TriePopulatorThreeTest do
  use ExUnit.Case, async: true
  @tp3 TriePopulatorThree

  test "populate with nothing" do
    assert @tp3.populate() === %{}
  end

  test "populate with empty string" do
    assert @tp3.populate("") === %{}
  end

  # we are skipping this for now as this model is a prototype and
  # I dont want the flakey test as part of main test suite
  @tag :skip
  test "populate with a" do
    expected = %{a: %{value: "a"}}

    assert @tp3.populate("a") === expected
  end

  test "populate with b" do
    expected = %{b: %{value: "b"}}

    assert @tp3.populate("b") === expected
  end

  @tag skip: true
  test "populate with a\nb" do
    expected = %{a: %{value: "a"}, b: %{value: "b"}}

    assert @tp3.populate("a\nb") === expected
  end

  test "populate with [a,b]" do
    expected = %{a: %{value: "a"}, b: %{value: "b"}}

    assert @tp3.populate(["a", "b"]) === expected
  end

  # we are skipping this for now as this model is a prototype and
  # I dont want the flakey test as part of main test suite
  @tag :skip
  test "populate with medium word list" do
    with {:ok, medium_text} <- medium_word_list() do
      trie = @tp3.populate(medium_text)

      result = trie[:f][:a][:s][:t][:h][:o][:l][:d][:value]

      assert result === "fasthold"
    end
  end

  @tag :skip
  test "populate with large word list" do
    with {:ok, large_text} <- large_word_list() do
      trie = @tp3.populate(large_text)

      result = trie[:v][:e][:t][:u][:s][:t][:value]

      assert result === "vetust"

      result = trie[:f][:a][:s][:t][:h][:o][:l][:d][:value]

      assert result === "fasthold"
    end
  end

  def medium_word_list do
    File.read("./test/medium.txt")
  end

  def large_word_list do
    File.read("/usr/share/dict/words")
  end
end
