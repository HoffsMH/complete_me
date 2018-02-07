defmodule TriePopulatorThreeTest do
  use ExUnit.Case
  @tp TriePopulatorThree

  test "populate with empty string" do
    assert @tp.populate("") === %{}
  end

  @tag :skip
  test "populate with a" do
    expected = %{a: %{value: "a"}}

    assert @tp.populate("a") === expected
  end

  @tag :skip
  test "populate with b" do
    expected = %{b: %{value: "b"}}

    assert @tp.populate("b") === expected
  end

  test "populate with a\nb" do
    expected = %{a: %{value: "a"}, b: %{value: "b"}}

    assert @tp.populate("a\nb") === expected
  end

  def medium_word_list do
    File.read("./test/medium.txt")
  end
end
