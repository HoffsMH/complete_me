medium_word_list = fn () -> File.read!("./test/medium.txt") end

large_word_list = fn () -> File.read!("/usr/share/dict/words") end


Benchee.run(%{
  "medium_one" => fn -> 
    with medium_text <- medium_word_list.() do
      trie = TriePopulator.populate(medium_text)
    end
  end,

  "medium_two" => fn -> 
    with medium_text <- medium_word_list.() do
      trie = TriePopulatorTwo.populate(medium_text)
    end
  end
},
formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
],
formatter_options: [html: [file: "benchmark_results/results.html"]],
)

