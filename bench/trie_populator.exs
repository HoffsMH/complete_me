with {:ok, medium_text} <- File.read("./test/medium.txt") do
  Benchee.run(%{
    "trie_pop" => fn -> TriePopulator.populate(medium_text) end,
    "trie_pop_2" => fn -> TriePopulatorTwo.populate(medium_text) end
  })
end
