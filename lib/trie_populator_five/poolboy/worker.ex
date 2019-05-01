defmodule TriePopulatorFive.Poolboy.Worker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:basic, num}, _from, state) do
    :timer.sleep(3000)
    IO.puts "received #{num}"
    {:reply, num, num}
  end
end
