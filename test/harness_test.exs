defmodule HarnessTest do
  use ExUnit.Case, async: true
  def equal(a, b), do: a === b
  @cm CompleteMe

  test "starting_count" do
    assert @cm.count() === 0
  end

  test "inserts_single_word" do
    model = @cm.insert("pizza")

    assert @cm.count(model) === 1
  end

  test "inserts_multiple_words" do
    model = @cm.populate("pizza\ndog\ncat")

    assert @cm.count(model) === 3
  end

  test "counts_inserted_words" do
    model = insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])

    assert @cm.count(model) === 5
  end

  @tag :skip
  test "suggests_off_of_small_dataset" do
    model = insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])

    assert @cm.suggest(model, "p") === ["pizza"]

    assert @cm.suggest(model, "piz") === ["pizza"]

    assert @cm.suggest(model, "zo") === ["zombies"]

    assert @cm.suggest(model, "a") === ["aardvark"]

    assert @cm.suggest(model, "aa") === ["aardvark"]
  end

  @tag :skip
  test "inserts_medium_dataset" do
    with {:ok, word_list} <- medium_word_list(),
         word_trie <- @cm.populate(word_list),
         word_count <- String.split(word_list, "\n") do
      @cm.count(word_trie)
      |> equal(word_count)
      |> assert
    else
      e -> assert false, e
    end
  end

  @tag :skip
  test "suggests_off_of_medium_dataset" do
    with {:ok, word_list} <- medium_word_list(),
         word_trie <- @cm.populate(word_list) do
      @cm.suggest(word_trie, "wi")
      |> List.sort()
      |> equal(["williwaw", "wizardly"])
      |> assert
    else
      e -> assert false, e
    end
  end

  @tag :skip
  test "selects_off_of_medium_dataset" do
    with {:ok, word_list} <- medium_word_list(),
         word_trie <- @cm.populate(word_list) do
      @cm.select(word_trie, "wi", "wizardly")
      |> @cm.suggest("wi")
      |> equal(["wizardly", "williwaw"])
      |> assert
    else
      e -> assert false, e
    end
  end

  @tag :skip
  test "works_with_large_dataset" do
    with {:ok, word_list} <- large_word_list(),
         word_trie <- @cm.populate(word_list) do
      suggestions = [
        "doggerel",
        "doggereler",
        "doggerelism",
        "doggerelist",
        "doggerelize",
        "doggerelizer"
      ]

      @cm.suggest(word_trie, "doggerel")
      |> List.sort()
      |> equal(suggestions)
      |> assert

      @cm.select(word_trie, "doggerel", "doggerelist")
      |> @cm.suggest("doggerel")
      |> List.first()
      |> equal("doggerelist")
      |> assert
    else
      e -> assert false, e
    end
  end

  def insert_words(words) do
    Enum.join(words, "\n")
    |> @cm.populate()
  end

  def medium_word_list do
    File.read("./test/medium.txt")
  end

  def large_word_list do
    File.read("/usr/share/dict/words")
  end
end
