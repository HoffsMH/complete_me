defmodule TriePopulatorFive do
  @default_job_limit 4

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

  def run(
        %{
          history: history,
          jobs: jobs,
          job_limit: job_limit,
          tries: [trie | tries],
          words: [word | words]
        } = state
      )
      when length(jobs) >= job_limit do
    with subword <- to_charlist(word) -- history,
         path <- Enum.map(subword, &List.to_atom([&1])) do
      run(%TriePopulatorFive{
        state
        | words: words,
          tries: tries ++ [TrieInserter.insert(trie, path, word)]
      })
    end
  end

  # if the job queue is full and there are no more tries to insert into existing words
  # finish up the existing jobs
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
      | jobs: jobs ++ [Task.async(fn -> Map.merge(trie1, trie2) end)],
        tries: rest
    }

    run(new_state)
  end

  def run(%{history: history, words: [word | rest]} = state) do
    if multiple_subwords?(state) do
      with {:ok, main_state, split_state} <- split_states(state) do
        run(%TriePopulatorFive{
          main_state
          | jobs:
              main_state.jobs ++
                [
                  split_job(history, split_state)
                ]
        })
      end
    else
      run(%TriePopulatorFive{
        state
        | words: rest,
          tries: state.tries ++ [finish_trie(word, history)]
      })
    end
  end

  def split_job(history, %{history: split_history} = split_state) do
    with outer_char <- [Enum.at(split_history, length(history))],
         outer_atom <- List.to_atom(outer_char) do
      Task.async(fn ->
        %{
          outer_atom => run(split_state)
        }
      end)
    end
  end

  def split_states(%{history: history, words: [word | _rest]} = state) do
    with next_character <- Enum.at(to_charlist(word), length(history)),
         split_history <- history ++ [next_character],
         split_state <- %TriePopulatorFive{history: split_history} do
      split_states(state, split_state)
    end
  end

  def split_states(%{words: []} = main_state, split_state), do: {:ok, main_state, split_state}

  def split_states(
        %{words: [word | rest]} = main_state,
        %{history: split_history} = split_state
      ) do
    if List.starts_with?(to_charlist(word), split_history) do
      split_states(
        %TriePopulatorFive{
          main_state
          | words: rest
        },
        %TriePopulatorFive{
          split_state
          | words: split_state.words ++ [word]
        }
      )
    else
      {:ok, main_state, split_state}
    end
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
