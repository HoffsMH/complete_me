require IEx

defmodule Tpt do
  use GenServer
  @ti TrieInserter

  def init(state), do: {:ok, state}

  def populate(words \\ "")

  def populate(words_text) when is_binary(words_text) do
    String.split(words_text, "\n")
    |> populate
  end

  def populate(word_list) when is_list(word_list) do
    word_list
    |> Enum.map(&start_trie_list/1)
    |> Enum.map(&Task.await/1)
  end

  def medium_word_list do
    {:ok, text} = File.read("./test/medium.txt")
    text
  end

  def pm do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
    populate(medium_word_list())
  end

  def start_trie_list(word) do
    Task.async(__MODULE__, :insert_single_trie, [word])
  end

  def insert_single_trie(word) do
    @ti.insert(word)
    |> load_trie
  end

  def load_trie(trie), do: GenServer.cast(__MODULE__, {:load_trie, trie})

  def handle_cast({:load_trie, trie}, state) do
    {:noreply, state ++ [trie]}
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end
end
