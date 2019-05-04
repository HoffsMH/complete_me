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
          %{c: %{a: %{t: %{a: %{c: %{o: %{m: %{b: %{value: "catacomb"}}}}}}}}},
          %{c: %{a: %{t: %{a: %{c: %{l: %{y: %{s: %{m: %{value: "cataclysm"}}}}}}}}}},
          %{c: %{a: %{t: %{b: %{a: %{c: %{k: %{value: "catback"}}}}}}}}
        ]
      }

      {:ok, state: state}
    end

    test "run/1 will eventually return a single trie", context do
      with %{state: state} <- context,
           result <- @subject.run(state) do
        assert result == %{
                 c: %{
                   a: %{
                     t: %{
                       a: %{
                         c: %{
                           l: %{y: %{s: %{m: %{value: "cataclysm"}}}},
                           o: %{m: %{b: %{value: "catacomb"}}}
                         }
                       },
                       b: %{a: %{c: %{k: %{value: "catback"}}}}
                     }
                   }
                 }
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
end
