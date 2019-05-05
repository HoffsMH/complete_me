defmodule TriePopulatorTest do
  use ExUnit.Case
  @subject TriePopulator

  describe "build_trie/1" do
    test "given a list of words runs insert on each until a single trie is formed" do
      with result <- @subject.build_trie(standard_word_list()) do
        assert result === %{
                 a: %{p: %{p: %{l: %{e: %{value: "apple"}}, value: "app"}}},
                 c: %{
                   a: %{
                     t: %{
                       a: %{
                         c: %{
                           l: %{y: %{s: %{m: %{value: "cataclysm"}}}},
                           o: %{m: %{b: %{value: "catacomb"}}}
                         }
                       },
                       b: %{a: %{c: %{k: %{value: "catback"}}}},
                       value: "cat"
                     }
                   }
                 }
               }
      end
    end
  end

  describe "basic use case with medium word list" do
    test "populates: each word in the file is findable on the list" do
      with words <- medium_word_list(),
           result <- @subject.populate(words) do
        medium_word_list()
        |> String.split("\n")
        |> Enum.reject(&(&1 === ""))
        |> Enum.each(fn word ->
          assert find_word(word, result) === word
        end)
      end
    end
  end

  def medium_word_list do
    File.read!("./test/support/fixtures/medium.txt")
  end

  def find_word(word, trie) do
    keys =
      String.graphemes(word)
      |> Enum.map(&String.to_atom/1)

    (keys ++ [:value])
    |> Enum.reduce(trie, fn key, sub_trie ->
      sub_trie[key]
    end)
  end

  def standard_word_list do
    [
      "app",
      "apple",
      "cat",
      "catacomb",
      "cataclysm",
      "catback"
    ]
  end
end
