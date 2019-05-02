defmodule TriePopulatorFiveTest do
  use ExUnit.Case, async: true
  @subject TriePopulatorFive

  describe "form_job_state/1" do
    test "does the thing" do
     x = sample_state

      assert true === false
    end
  end

  test "A" do
    state = %TriePopulatorFive{
      history: ["c", "a", "t"],
      words: ["catacomb", "cataclysm"]
    }


    result = @subject.next_is_sub?(state)

    require IEx; IEx.pry

    assert true == false

    require IEx; IEx.pry
  end

  defp sample_state do
    %TriePopulatorFive{}
  end
end
