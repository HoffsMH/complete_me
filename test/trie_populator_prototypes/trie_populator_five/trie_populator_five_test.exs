defmodule TriePopulatorFiveTest do
  use ExUnit.Case
  @subject TriePopulatorFive

  describe "there are still multiple subwords grouped together" do
    setup do
      state = %TriePopulatorFive{
        history: 'cat',
        words: ["cataclysm", "catacomb", "catback"]
      }

      {:ok, state: state}
    end

    test "subwords?/1 should yield true", context do
      with %{state: state} <- context do
        result = @subject.multiple_subwords?(state)
        assert result == true
      end
    end
  end

  describe "there are still multiple subwords grouped together with more history" do
    setup do
      state = %TriePopulatorFive{
        history: 'cata',
        words: ["cataclysm", "catacomb", "catback"]
      }

      {:ok, state: state}
    end

    test "subwords?/1 should yield true", context do
      with %{state: state} <- context do
        result = @subject.multiple_subwords?(state)
        assert result == true
      end
    end
  end

  describe "there are no subwords of the first word and history is on the edge of current word" do
    setup do
      state = %TriePopulatorFive{
        history: 'catac',
        words: ["cataclysm", "catacomb", "catback"]
      }

      {:ok, state: state}
    end

    test "subwords?/1 should yield false", context do
      with %{state: state} <- context do
        result = @subject.multiple_subwords?(state)
        assert result == false
      end
    end
  end

  describe "when there is only one subword before the list separates" do
    setup do
      state = %TriePopulatorFive{
        history: 'cat',
        words: ["cataclysm", "catback"]
      }

      {:ok, state: state}
    end

    test "subwords?/1 should yield false", context do
      with %{state: state} <- context do
        result = @subject.multiple_subwords?(state)
        assert result == false
      end
    end
  end

  describe "when there is only one word left in entire words list" do
    setup do
      state = %TriePopulatorFive{
        history: 'cat',
        words: ["cataclysm"]
      }

      {:ok, state: state}
    end

    test "subwords?/1 should yield false", context do
      with %{state: state} <- context do
        result = @subject.multiple_subwords?(state)
        assert result == false
      end
    end
  end

  describe """
  when there is only one trie in the trie list and there are no words or jobs
  """ do
    setup do
      state = %TriePopulatorFive{
        words: [],
        jobs: [],
        tries: ["some_trie"]
      }

      {:ok, state: state}
    end

    test "run/1 returns the trie", context do
      with %{state: state} <- context,
           result <- @subject.run(state) do
        assert result === "some_trie"
      end
    end
  end

  describe "finish_trie/2" do
    test "when history and word match returns the value map" do
      result = @subject.finish_trie("catacomb", 'catacomb')

      assert result == %{
               value: "catacomb"
             }
    end

    test "finishes the trie when incomplete" do
      result = @subject.finish_trie("catacomb", 'catac')

      assert result === %{
               o: %{
                 m: %{
                   b: %{
                     value: "catacomb"
                   }
                 }
               }
             }
    end

    test "when history is empty should make whole trie" do
      result = @subject.finish_trie("catacomb", '')

      assert result == %{c: %{a: %{t: %{a: %{c: %{o: %{m: %{b: %{value: "catacomb"}}}}}}}}}
    end
  end

  describe "when there are multiple tries, no words and no jobs" do
    setup do
      state = %TriePopulatorFive{
        tries: [
          %{o: %{m: %{b: %{value: "catacomb"}}}},
          %{l: %{y: %{s: %{m: %{value: "cataclysm"}}}}}
        ]
      }

      {:ok, state: state}
    end

    test "run/1 will eventually return a single trie", context do
      with %{state: state} <- context,
           result <- @subject.run(state) do
        assert result == %{
                 l: %{y: %{s: %{m: %{value: "cataclysm"}}}},
                 o: %{m: %{b: %{value: "catacomb"}}}
               }
      end
    end
  end

  describe "when there are no tries and no words and a single job pending" do
    setup do
      state = %TriePopulatorFive{
        jobs: [
          Task.async(fn ->
            %{c: %{a: %{t: %{b: %{a: %{c: %{k: %{value: "catback"}}}}}}}}
          end)
        ]
      }

      {:ok, state: state}
    end

    test "should wait for the job to finish then eventually return the result", context do
      with %{state: state} <- context do
        result = @subject.run(state)
        assert result == %{c: %{a: %{t: %{b: %{a: %{c: %{k: %{value: "catback"}}}}}}}}
      end
    end
  end

  describe "when there is a single word" do
    setup do
      state = %TriePopulatorFive{
        words: ["catacomb"]
      }

      {:ok, state: state}
    end

    test "run/1 will return a trie containing that word", context do
      with %{state: state} <- context do
        result = @subject.run(state)
        assert result === %{c: %{a: %{t: %{a: %{c: %{o: %{m: %{b: %{value: "catacomb"}}}}}}}}}
      end
    end
  end

  describe "when there are multiple words" do
    setup do
      state = %TriePopulatorFive{
        words: ["catacomb", "cataclysm"]
      }

      {:ok, state: state}
    end

    test "run/1 will return a trie containing those words", context do
      with %{state: state} <- context do
        result = @subject.run(state)

        assert result === %{
                 c: %{
                   a: %{
                     t: %{
                       a: %{
                         c: %{
                           o: %{m: %{b: %{value: "catacomb"}}},
                           l: %{y: %{s: %{m: %{value: "cataclysm"}}}}
                         }
                       }
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
        |> Enum.each(fn word ->
          assert find_word(word, result) === word
        end)
      end
    end
  end

  describe "split_states/1" do
    setup do
      state = %TriePopulatorFive{
        history: 'catac',
        words: [
          "cataclysm",
          "cataclock",
          "cataclambake",
          "catacomb",
          "catback"
        ]
      }

      {:ok, state: state}
    end

    test "it splits the states in 2", context do
      with %{state: state} <- context,
           {:ok, main_state, split_state} <- @subject.split_states(state) do
        assert main_state == %TriePopulatorFive{
                 history: 'catac',
                 words: [
                   "catacomb",
                   "catback"
                 ]
               }

        assert split_state == %TriePopulatorFive{
                 history: 'catacl',
                 words: [
                   "cataclysm",
                   "cataclock",
                   "cataclambake"
                 ]
               }
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
end
