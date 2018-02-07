defmodule TriePopulatorThree do
  @ti TrieInserter

  def populate(words \\ "")

  def populate(words) do
    Agent.start_link(fn -> [] end, name: Tries)
    Agent.start_link(fn -> false end, name: LastCall)
    do_things()

    words
    |> Words.to_list()
    |> Enum.map(&ok_what/1)

    # tell do_things last call
    Agent.update(LastCall, fn status -> true end)

  end

  def do_things do
    # are there 2 things in the Agent state
    Agent.update(Tries, fn  trie_list -> 
      with [a, b | rest] <- trie_list do
        spawn(Fox, :thing_two, [a,b])
        IO.puts('it had atleast two');
        rest
      else

        _ ->

          IO.puts('it had less than two');
          trie_list
      end
    end)
    Agent.update(LastCall, fn status -> 
      if status === true do
      else
        do_things()
      end
      status
    end)
  end

  def populate_medium do
    #TriePopulatorThree.populate_medium
    populate(medium_word_list)
  end

  def medium_word_list do
    File.read!("./test/medium.txt")
  end

  def ok_what(word) do
    spawn(Fox, :thing, [word])
  end
end

defmodule Fox do
  def thing(word) do
    trie = TrieInserter.insert(word)

    Agent.update(Tries, &( [trie | &1 ] ))
    exit(:done)
  end

  def thing_two(a, b) do
    trie = TrieMerger.merge(a,b)

    Agent.update(Tries, &( [trie | &1 ] ))
    exit(:done)
  end

  # |> Enum.reduce(new_trie(), &@ti.insert(&2, &1))
  # TrieInserter  
end

# defmodule Example do
#   def add(a, b) do
#     IO.puts(a + b)
#   end
# end

# spawn(Example, :add, [2, 3])
# # will spawn and output 5

# # what could this be?
# #  we could build a trie in here
# # when done we could
# defmodule Example do
#   def listen do
#     receive do
#       message -> IO.puts(message)
#     end

#     listen()
#   end
# end

# pid = spawn(Example, :listen, [])

# send pid, "hello"
