defmodule TriePopulatorFiveTest do
  use ExUnit.Case, async: true
  @subject TriePopulatorFive

  @tag :skip
  describe "form_job_state/1" do
    test "does the thing" do
      assert true === false
    end
  end

  @tag :skip
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
end
