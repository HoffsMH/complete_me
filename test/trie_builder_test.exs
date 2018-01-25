defmodule TrieBuilderTest do
  use ExUnit.Case, async: true
  def equal(a, b), do: a === b
  @tb TrieBuilder
  
  test "insert with nothing" do
    @tb.insert()
    |> equal(%{})
    |> assert
  end

  test "insert with a simple word" do
    @tb.insert("")
    |> equal(%{})
    |> assert
  end

  test "insert with a" do
    @tb.insert("a")
    |> equal(%{a: %{ value: "a"}})
    |> assert
  end
end
