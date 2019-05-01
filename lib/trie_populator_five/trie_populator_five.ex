# defmodule TriePopulatorFive do
#   def thing do
#     TriePopulatorFive.Poolboy.Application.start(:normal, [])
#     1..50
#     |> Enum.map(fn num ->
#       Task.async(fn ->
#         :poolboy.transaction(:tp5Pool, fn pid ->
#           GenServer.call(pid, {:basic, num})
#         end)
#       end)
#     end)
#     |> Enum.map(&Task.await(&1))
#     |> IO.inspect()
#   end

#   def main(%{words: words, tries: tries}) do

#   end
# end
