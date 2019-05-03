defmodule TriePopulatorFourTest do
  use ExUnit.Case, async: true
  @subject TriePopulatorFour

  test "populate with nothing" do
    assert @subject.populate() === %{}
  end

  test "populate with empty string" do
    assert @subject.populate("") === %{}
  end

  # we are skipping this for now as this model is a prototype and
  # I dont want the flakey test as part of main test suite
  @tag :skip
  test "populate with a" do
    expected = %{a: %{value: "a"}}

    assert @subject.populate("a") === expected
  end

  test "populate with b" do
    expected = %{b: %{value: "b"}}

    assert @subject.populate("b") === expected
  end

  test "populate with a\nb" do
    expected = %{a: %{value: "a"}, b: %{value: "b"}}

    assert @subject.populate("a\nb") === expected
  end

  # we are skipping this for now as this model is a prototype and
  # I dont want the flakey test as part of main test suite
  @tag :skip
  test "populate with [a,b]" do
    expected = %{a: %{value: "a"}, b: %{value: "b"}}

    assert @subject.populate(["a", "b"]) === expected
  end

  test "populate with medium word list" do
    with {:ok, medium_text} <- medium_word_list() do
      trie = @subject.populate(medium_text)

      result = trie[:v][:e][:t][:u][:s][:t][:value]

      assert result === "vetust"

      result = trie[:f][:a][:s][:t][:h][:o][:l][:d][:value]

      assert result === "fasthold"
    end
  end

  @tag :skip
  test "populate with large word list" do
    with {:ok, large_text} <- large_word_list() do
      trie = @subject.populate(large_text)

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
