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
    assert @cm.count(%{words: []}) === 0
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

  test "count with populated model does not allow duplicates" do
    model =
      @cm.insert("hello")
      |> @cm.insert("goodbye")
      |> @cm.insert("what")
      |> @cm.insert("ok")
      |> @cm.insert("what")

    assert @cm.count(model) === 4
  end

  test "fresh populate with no params" do
    assert @cm.populate() === %{
             trie: %{},
             words: []
           }
  end

  test "fresh populate a" do
    assert @cm.populate("a") === %{
             trie: %{a: %{value: "a"}},
             words: ["a"]
           }
  end

  test "fresh populate a\nb" do
    assert @cm.populate("a\nb") === %{
             trie: %{a: %{value: "a"}, b: %{value: "b"}},
             words: ["a", "b"]
           }
  end

  test "fresh populate a\nb\nb" do
    assert @cm.populate("a\nb\nb") === %{
             trie: %{a: %{value: "a"}, b: %{value: "b"}},
             words: ["a", "b"]
           }
  end

  test "populate with no args" do
    assert @cm.suggest() === %{trie: %{}, words: []}
  end
end
