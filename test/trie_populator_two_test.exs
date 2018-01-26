defmodule TriePopulatorTwoTest do
  use ExUnit.Case, async: true
  @tp2 TriePopulatorTwo

  test "populate with nothing" do
    assert @tp2.populate() === %{}
  end

  test "populate with empty string" do
    assert @tp2.populate("") === %{}
  end

  test "populate with a" do
    expected = %{a: %{value: "a"}}

    assert @tp2.populate("a") === expected
  end

  test "populate with b" do
    expected = %{b: %{value: "b"}}

    assert @tp2.populate("b") === expected
  end

  test "populate with a\nb" do
    expected = %{a: %{ value: "a" }, b: %{value: "b"}}

    assert @tp2.populate("a\nb") === expected
  end

  test "populate with [a,b]" do
    expected = %{a: %{ value: "a" }, b: %{value: "b"}}

    assert @tp2.populate(["a", "b"]) === expected
  end

  test "populate with medium word list" do
    with {:ok, medium_text} <- medium_word_list()
    do
      trie = @tp2.populate(medium_text)
      
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
