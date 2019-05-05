defmodule TriePopulatorOneTest do
  use ExUnit.Case, async: true
  @tp TriePopulatorOne

  test "populate with nothing" do
    assert @tp.populate() === %{}
  end

  test "populate with empty string" do
    assert @tp.populate("") === %{}
  end

  test "populate with a" do
    expected = %{a: %{value: "a"}}

    assert @tp.populate("a") === expected
  end

  test "populate with b" do
    expected = %{b: %{value: "b"}}

    assert @tp.populate("b") === expected
  end

  test "populate with a\nb" do
    expected = %{a: %{value: "a"}, b: %{value: "b"}}

    assert @tp.populate("a\nb") === expected
  end

  test "populate with [a,b]" do
    expected = %{a: %{value: "a"}, b: %{value: "b"}}

    assert @tp.populate(["a", "b"]) === expected
  end

  test "populate with medium word list" do
    with {:ok, medium_text} <- medium_word_list() do
      trie = @tp.populate(medium_text)

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
