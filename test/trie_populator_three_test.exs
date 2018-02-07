defmodule TriePopulatorTest do
  use ExUnit.Case
  @tp TriePopulatorThree

  test "populate with nothing" do
    assert @tp.populate() === %{}
  end

  def medium_word_list do
    File.read("./test/medium.txt")
  end
end
