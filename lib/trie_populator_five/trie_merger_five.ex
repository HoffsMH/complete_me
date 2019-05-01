# defmodule TrieMergerFive do
#   @moduledoc """
#   receives an initial state that is a count of the remaining jobs
#   of trie formation
#   this count decrements every time a trie is added to state
#   every time a word is added to state

#   every time a trie is merged we check to see  if remaining is 0
#   and the trie count is 1
#   """

#   def main(%{ words: words, accum: accum }) do
#     words
#     |> Enum.each
#   end

#   def handle_call({:add_to_sub_tries, sub_trie, word}, _from, state) do
#     state.words -- word
#     state.sub_trie + subtrie

#     Task.async(
#       :poolboy.transaction(
#         fn pid -> call({:merge, }) end
#       )
#     )

#   end


#   def handle_call({:merge, trie}, _from, stat) do
#     state.trie trie
#   end

#   def handle_cast({:form_sub_trie, word}, _from, state) do
#     word
#     TrieInserterFive.insert(word)

#   end
# end
