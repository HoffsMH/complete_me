defmodule TriePopulatorFour.Worker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({merge_and_load, [a, b]}, _from, state) do
    TriePopulatorFour.merge_and_load(a, b)
    {:reply, state, state}
  end
end
