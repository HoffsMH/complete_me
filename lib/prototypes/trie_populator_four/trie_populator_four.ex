defmodule TriePopulatorFour do
  use GenServer
  @ti TrieInserter
  @tm TrieMerger

  def init(state), do: {:ok, state}

  def populate(words \\ "")

  def populate(words_text) when is_binary(words_text) do
    String.split(words_text, "\n")
    |> populate
  end

  def populate(word_list) when is_list(word_list) do
    GenServer.start_link(__MODULE__, initial_state(), name: __MODULE__)
    TriePopulatorFour.Application.start(:normal, [])

    trie_inserts =
      word_list
      |> Enum.map(&start_trie_list/1)

    {_pid, ref} = start_combining()

    trie_inserts
    |> Enum.each(&Task.await/1)

    done_inserting()

    receive do
      {:DOWN, ^ref, :process, _from_pid, _reason} ->
        get_first_trie()
    end
  end

  def done_inserting() do
    GenServer.call(__MODULE__, {:done_inserting}, :infinity)
  end

  def handle_call({:done_inserting}, _from, state) do
    {:reply, :ok, %{state | doneInserting: true}}
  end

  def handle_call({:first_two_tries}, _from, state) do
    cond do
      length(state.tries) > 1 ->
        [a, b | new_tries] = state.tries
        {:reply, {:success, [a, b]}, %{state | tries: new_tries}}

      state.doneInserting ->
        {:reply, {:done}, state}

      true ->
        {:reply, {:empty, []}, state}
    end
  end

  def start_combining do
    spawn_monitor(__MODULE__, :combine, [])
  end

  def combine do
    with {:success, [a, b]} <- pull_out_first_two() do
      # Task.async(__MODULE__, :merge_and_load, [a, b])

      :poolboy.transaction(
        :worker,
        fn pid -> GenServer.call(pid, {:merge_and_load, [a, b]}) end,
        60000
      )

      combine()
    else
      {:empty, []} ->
        combine()

      {:done} ->
        exit(:done)
    end
  end

  def merge_and_load(a, b) do
    load_trie(@tm.merge(a, b))
  end

  def pull_out_first_two() do
    GenServer.call(__MODULE__, {:first_two_tries}, :infinity)
  end

  def initial_state do
    %{
      tries: [],
      doneInserting: false
    }
  end

  def start_trie_list(word) do
    Task.async(__MODULE__, :insert_single_trie, [word])
  end

  def insert_single_trie(word) do
    @ti.insert(word)
    |> load_trie
  end

  def load_trie(trie), do: GenServer.cast(TriePopulatorFour, {:load_trie, trie})

  def handle_cast({:load_trie, trie}, state) do
    {:noreply, %{state | tries: state.tries ++ [trie]}}
  end

  def get_first_trie do
    GenServer.call(__MODULE__, {:first_trie}, :infinity)
  end

  def handle_call({:first_trie}, _from, state) do
    if length(state.tries) === 0 do
      {:reply, state, state}
    else
      {:reply, hd(state.tries), state}
    end
  end
end
