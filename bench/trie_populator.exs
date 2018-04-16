with {:ok, medium_text} <- File.read("./test/medium.txt") do
  Benchee.run(%{
    "trie_pop"    => fn -> TriePopulator.populate(medium_text) end
  })
end
