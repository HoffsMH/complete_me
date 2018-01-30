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

  @tag :skip
  test "inserts_multiple_words" do
    @cm.populate("pizza\ndog\ncat")
    |> @cm.count()
    |> equal(3)
    |> assert
  end

  @tag :skip
  test "counts_inserted_words" do
    insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
    |> @cm.count()
    |> equal(5)
    |> assert
  end

  @tag :skip
  test "suggests_off_of_small_dataset" do
    trie =
      insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
      |> @cm.suggest("p")
      |> equal(["pizza"])
      |> assert

    @cm.suggest(trie, "piz")
    |> equal(["pizza"])
    |> assert

    @cm.suggest(trie, "zo")
    |> equal(["zombies"])
    |> assert

    @cm.suggest(trie, "a")
    |> equal(["a", "aardvark"])
    |> assert

    @cm.suggest(trie, "aa")
    |> equal(["aardvark"])
    |> assert
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
