defmodule TriePopulatorFive do

  @default_job_limit 4

  # @type t ::  %__MODULE__{
  #   history:
  #   tries:
  #   words:
  #   jobs:
  #   job_limit:
  # }

  defstruct [
    history: '',
    tries: [],
    words: [],
    jobs: [],
    job_limit: @default_job_limit
  ]


  def run(state) do
    # if length(state.jobs) >= state.job_limit ||  length(state.words) <= 0 do
    #   state.jobs
    #   |> Enum.map(&Task.await/1)
    #   # put them in state.tries
    # end

    # if length(state.tries) > 1 do
    #   merge_left(state.tries) ++ state.jobs
    # end

    # [Task.async(fn ->
    #     # all sub words on list sent to another job

    #   end) | state.jobs]

    # run(state)
  end

  @doc """
  function that takes state and returns 2 new states
  one state to return to same process
  one state to return to a branched process that will solve for a certain subset
  """

end
