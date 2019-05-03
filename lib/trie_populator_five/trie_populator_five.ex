defmodule TriePopulatorFive do
  @default_job_limit 4

  # @type t ::  %__MODULE__{
  #   history:
  #   tries:
  #   words:
  #   jobs:
  #   job_limit:
  # }

  defstruct history: '',
            tries: [],
            words: [],
            jobs: [],
            job_limit: @default_job_limit

  # when all jobs are done and there are no more words and only a single trie
  # remains in trie list its time to actually return the final trie
  def run(%{jobs: [], tries: tries, words: []})
      when length(tries) == 1,
      do: List.first(tries)

  # if the job queue is full, wait for some jobs to finish and
  # add the produced sub tries to the list of tries to be merged
  def run(%{jobs: jobs, job_limit: job_limit} = state)
      when length(jobs) >= job_limit do
    new_tries =
      jobs
      |> Enum.map(&Task.await/1)

    run(%{
      state
      | tries: new_tries ++ state.tries,
        jobs: []
    })
  end

  # if there are more than one tries left in tries then make jobs to merge them
  def run(%{tries: [trie1, trie2 | rest], jobs: jobs} = state) do
    run(%{
      state
      | jobs: jobs ++ Task.async(fn -> TrieMerger.merge(trie1, trie2) end),
        tries: rest
    })
  end

  def run(%{words: words}) do
  end

  def run(%{tries: [trie]}) do
    trie
  end

  def run(state) do
    # if length(state.jobs) >= state.job_limit ||  length(state.words) <= 0 do
    #   state.jobs
    #   |> Enum.map(&Task.await/1)
    #   # put them in state.tries
    # end

    # if length(state.tries) > 1 do
    #   merge_left(state.tries) ++ state.jobs
    # end

    # if state.history === words[0]

    # [Task.async(fn ->
    #     # all sub words on list sent to another job

    #   end) | state.jobs]

    # run(state)
  end

  def multiple_subwords?(%{history: history, words: [word1, word2 | _]}) do
    with next_character <- Enum.at(to_charlist(word1), length(history)),
         word <- history ++ [next_character] do
      List.starts_with?(to_charlist(word2), word)
    end
  end

  def multiple_subwords?(%{words: [word]}), do: false

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
