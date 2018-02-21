defmodule Tpt do
  @ti TrieInserter
  @tm TrieMerger

  defp generate_model(process) do
      %{ 
        process: process,
        trie_build_jobs: [],
        trie_merge_jobs: [],
        tries: []
      }
  end

  def thing(word) do
    Agent.update(Tpt.Model, fn (model) ->
      %{
        model | 
        trie_build_jobs: [ spawn(fn -> 
          trie = @ti.insert(word)
          me = self()
          Agent.update(Tpt.Model, fn model -> 
            %{
              model |
              tries: [trie | model[:tries]],
              trie_build_jobs: model[:trie_build_jobs] -- [me]
            }
          end)
        end) | model[:trie_build_jobs]]
      }
    end)
  end

  def start_some_other_process do
    selfie = self()
    Agent.start_link(fn -> generate_model(selfie) end, name: Tpt.Model);
    spawn(&something_that_recurses/0)
  end

  def something_that_recurses do
    Agent.update(Tpt.Model, fn model -> 
      
      new_model = update(model)
      
      if new_model[:status] === "done" do
        send(new_model[:process], {:result, new_model[:tries]})
        exit(:normal)
      end

      new_model
    end)
    something_that_recurses()
  end

  def update(model) do
    IO.puts("merge: ")
    IO.puts(length(model[:trie_merge_jobs]))
    IO.puts("build: ")
    IO.puts(length(model[:trie_build_jobs]))
    IO.puts("tries: ")
    IO.inspect(length(model[:tries]))
    peel_off_two_tries_and_send_them_to_be_merged(model)
  end

  def peel_off_two_tries_and_send_them_to_be_merged(model) do
    with [a, b | rest ] <- model[:tries] do
      %{
        model |
        tries: rest,
        trie_merge_jobs: [ spawn(fn ->
        trie = @tm.merge(a, b)
        me = self()
        Agent.update(Tpt.Model, fn model ->
          %{
            model |
            tries: [trie | model[:tries]],
            trie_merge_jobs: model[:trie_merge_jobs] -- [me]
          }
        end)
      end) | model[:trie_merge_jobs]]
      }
    else
      _ -> 
        if all_done(model) do
          Map.put(model, :status, "done")
        else
          model
        end
    end
  end

  def all_done(model) do
    !List.first(model[:trie_merge_jobs]) &&
    !List.first(model[:trie_build_jobs]) &&
    length(model[:tries]) === 1
  end

  def p() do
    start_some_other_process()

    medium_word_list()
    |> Words.to_list()
    |> Enum.each(&thing/1)

    receive do
      {:result, result} -> result
    end
  end

  def pt() do
    start_some_other_process()

    large_word_list()
    |> Words.to_list()
    |> Enum.each(&thing/1)

    receive do
      {:result, result} -> result
    end
  end

  def large_word_list do
   File.read!("/usr/share/dict/words") 
  end

  def medium_word_list do
   File.read!("./test/medium.txt")
  end
end
