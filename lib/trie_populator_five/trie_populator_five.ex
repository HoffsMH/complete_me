defmodule TriePopulatorFive do
  @default_job_limit 20

  @type t :: %__MODULE__{
          history: charlist,
          tries: [map],
          words: [String.t()],
          jobs: [Task.Async.t()],
          job_limit: integer
        }

  defstruct history: '',
            tries: [],
            words: [],
            jobs: [],
            job_limit: @default_job_limit


  def populate(words \\ "")

  def populate(words_text) when is_binary(words_text) do
    String.split(words_text, "\n")
    |> populate
  end

  def populate(word_list) when is_list(word_list) do
    run(%TriePopulatorFive{
          words: word_list
        })
  end

  # when all jobs are done and there are no more words and only a single trie
  # remains in trie list its time to actually return the final trie
  def run(%{jobs: [], tries: tries, words: []})
      when length(tries) == 1,
      do: List.first(tries)

  # if the job queue is full, wait for some jobs to finish and
  # add the produced sub tries to the list of tries to be merged
  def run(%{jobs: jobs, job_limit: job_limit} = state)
      when length(jobs) >= job_limit,
      do: harvest_jobs(state)

  def run(%{words: [], jobs: jobs} = state)
      when length(jobs) > 0,
      do: harvest_jobs(state)


  # if there are more than one tries left in tries then make jobs to merge them
  def run(%{tries: [trie1, trie2 | rest], jobs: jobs} = state) do
    new_state = %TriePopulatorFive{
      state
      | jobs: jobs ++ [Task.async(fn -> TrieMerger.merge(trie1, trie2) end)],
        tries: rest
    }

    run(new_state)
  end

  def run(%{history: history, words: [word | rest]} = state) do
    # if multiple_subwords?(state) do
    #   with {main_state, split_state} <- split_states(state) do
    #     run(%TriePopulatorFive{
    #           main_state |
    #           jobs: main_state.jobs ++ [
    #             Task.async(fn ->
    #               run(split_state)
    #             end)
    #           ]

    #         }
    #     )
    #   else
    #     run(%TriePopulatorFive{
    #           state |
    #           words: rest,
    #           tries: state.tries ++ [finish_trie(word, history)]
    #         })
    #   end
    # end

    run(%TriePopulatorFive{
          state |
          words: rest,
          tries: state.tries ++ [finish_trie(word, history)]
        })
  end

  def split_states(%{history: history, words: [word | rest]} = state) do
    # determine the full prefix for future iterations

    # split_states
    # history


    # with next_character <- Enum.at(to_charlist(word1), length(history)),
    #      prefix <- history ++ [next_character] do
    #   split_states(state, )
    # end

    # {state}
  end

  def split_states(%{words: [word | rest] }, split) do

    # if the word begins with the prefix put in the split state and recurse
    # if the word doesn't begin witht he prefix return a tuple of both states

    # split_states(%TriePopulatorFive{
    #       main |
    #       words: rest

    #              })
  end

  def harvest_jobs(%{jobs: jobs} = state) do
    new_tries =
      jobs
      |> Enum.map(&Task.await/1)

    run(%{
          state
          | tries: new_tries ++ state.tries,
          jobs: []
        })
  end

  def multiple_subwords?(%{history: history, words: [word1, word2 | _]}) do
    with next_character <- Enum.at(to_charlist(word1), length(history)),
         word <- history ++ [next_character] do
      List.starts_with?(to_charlist(word2), word)
    end
  end

  def multiple_subwords?(%{words: [_]}), do: false

  def finish_trie(word, history) when word == history, do: %{value: to_string(word)}

  def finish_trie(word, history)
      when is_binary(word),
      do: finish_trie(to_charlist(word), history)

  def finish_trie(word, history) do
    remaining = word -- history
    [current | _] = remaining

    %{
      List.to_atom([current]) => finish_trie(word, history ++ [current])
    }
  end
end
