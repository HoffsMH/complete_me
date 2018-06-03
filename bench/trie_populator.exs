# def large_word_list do
#     File.read("/usr/share/dict/words")
#   end

# {:ok, text} = File.read("./test/medium.txt") # 1000 words
{:ok, text} = File.read("/usr/share/dict/words") # over 200k words

Benchee.run(%{
  "trie_pop" => fn -> TriePopulator.populate(text) end,
  # "trie_pop_2" => fn -> TriePopulatorTwo.populate(text) end,
  # "trie_pop_3" => fn -> TriePopulatorThree.populate(text) end,
  # "trie_pop_4" => fn -> TriePopulatorFour.populate(text) end,
  "trie_pop_5" => fn -> TriePopulatorFive.populate(text) end,
  "trie_pop_6" => fn -> TriePopulatorSix.populate(text) end,
  "trie_pop_7" => fn -> TriePopulatorSeven.populate(text) end,
  "trie_pop_8" => fn -> TriePopulatorEight.populate(text) end
})
