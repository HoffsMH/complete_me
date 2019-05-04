{:ok, text} = File.read("./test/support/fixtures/medium.txt")

# If you are going to use the large word list you might want to disable 2-4 since
# those appear to be O^2
# {:ok, text} = File.read("/usr/share/dict/words")

Benchee.run(%{
  "trie_pop" => fn -> TriePopulator.populate(text) end,
  "trie_pop_2" => fn -> TriePopulatorTwo.populate(text) end,
  "trie_pop_3" => fn -> TriePopulatorThree.populate(text) end,
  "trie_pop_4" => fn -> TriePopulatorFour.populate(text) end,
  "trie_pop_5" => fn -> TriePopulatorFive.populate(text) end
})
