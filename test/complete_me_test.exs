defmodule CompleteMeTest do
  use ExUnit.Case, async: true
  doctest CompleteMe

  @cm CompleteMe

  test "model formation with insert nothing" do
    assert @cm.insert() === %{trie: %{}, words: []}
  end

  test "model formation with insert simple word" do
    assert @cm.insert("f") === %{
             trie: %{f: %{value: "f"}},
             words: ["f"]
           }
  end

  test "count with no model" do
    assert @cm.count() === 0
  end

  test "count with empty model" do
    assert @cm.count(%{}) === 0
  end

  test "count with populated model" do
    model =
      @cm.insert("hello")
      |> @cm.insert("goodbye")

    assert @cm.count(model) === 2
  end

  test "count with populated model two" do
    model =
      @cm.insert("hello")
      |> @cm.insert("goodbye")
      |> @cm.insert("ok")
      |> @cm.insert("what")

    assert @cm.count(model) === 4
  end
end
