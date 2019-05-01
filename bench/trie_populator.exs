# def large_word_list do
#     File.read("/usr/share/dict/words")
#   end

{:ok, medium_text} = File.read("./test/medium.txt")

Benchee.run(%{
  "trie_pop" => fn -> TriePopulator.populate(medium_text) end,
  "trie_pop_2" => fn -> TriePopulatorTwo.populate(medium_text) end,
  "trie_pop_3" => fn -> TriePopulatorThree.populate(medium_text) end,
  "trie_pop_4" => fn -> TriePopulatorFour.populate(medium_text) end
})
