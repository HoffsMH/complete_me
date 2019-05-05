gen_tests = fn text ->
  # If you are going to use the large word list you might
  # want to disable trie_pop 2-4 since those appear to be O^2 :(
  tests = %{
    "trie_pop_1" => fn -> TriePopulatorOne.populate(text) end,
    "trie_pop_2" => fn -> TriePopulatorTwo.populate(text) end,
    "trie_pop_3" => fn -> TriePopulatorThree.populate(text) end,
    "trie_pop_4" => fn -> TriePopulatorFour.populate(text) end,
    "trie_pop_5" => fn -> TriePopulatorFive.populate(text) end
  }

  full_tests =
    Enum.reduce(3..10, tests, fn portions, map ->
      Map.put(map, "trie_pop_6_with_#{portions}_portions", fn ->
        TriePopulator.populate(text, portions)
      end)
    end)

  full_tests
end

Benchee.run(gen_tests.(File.read!("./test/support/fixtures/medium.txt")))

# large word list around 250k (cpu intensive)
# Benchee.run(gen_tests.(File.read!("/usr/share/dict/words")))
