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

  describe "determine_portion_size/2" do
    test "when given arguments that should otherwise cause output to be 0" do
      with result <- @subject.determine_portion_size(["a"], 20) do
        assert result === 1
      end
    end

    test "when given 0 as a portions arg" do
      assert_raise(
        FunctionClauseError,
        fn ->
          @subject.determine_portion_size(["a"], 0)
        end
      )
    end
  end

  describe "edge cases" do
    test "when given empty string returns a blank trie" do
      with result <- @subject.populate("") do
        assert result === %{}
      end
    end

    test "when given no arguments returns a blank trie" do
      with result <- @subject.populate() do
        assert result === %{}
      end
    end

    test "when given no arguments for portions and max portion size" do
      with result <- @subject.populate("adfasdfasdfasdf") do
        assert result === %{
                 a: %{
                   d: %{
                     f: %{
                       a: %{
                         s: %{
                           d: %{
                             f: %{
                               a: %{
                                 s: %{
                                   d: %{f: %{a: %{s: %{d: %{f: %{value: "adfasdfasdfasdf"}}}}}}
                                 }
                               }
                             }
                           }
                         }
                       }
                     }
                   }
                 }
               },
               "still valiantly forms the trie!"
      end
    end

    test """
    when given no arguments for max and an impossible argument for portions
    """ do
      with result <- @subject.populate("adfasdfasdfasdf", 20_000) do
        assert result === %{
                 a: %{
                   d: %{
                     f: %{
                       a: %{
                         s: %{
                           d: %{
                             f: %{
                               a: %{
                                 s: %{
                                   d: %{f: %{a: %{s: %{d: %{f: %{value: "adfasdfasdfasdf"}}}}}}
                                 }
                               }
                             }
                           }
                         }
                       }
                     }
                   }
                 }
               },
               "still valiantly forms the trie!"
      end
    end
  end

  describe "basic use case with medium word list" do
    test "populates: each word in the file is findable on the list" do
      with words <- medium_word_list(),
           result <- @subject.populate(words) do
        # each word on list is findable within the trie
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
