require IEx;

defmodule HarnessTest do
  use ExUnit.Case
  
  def equal(a, b), do: a === b
  
  def insert_words(words) do
    Enum.join(words, "\n") 
      |> CompleteMe.populate()
  end

  def medium_word_list do
   File.read!("./test/medium.txt")
  end

  test "test_starting_count" do
    assert CompleteMe.count() === 0
  end

  test "test_inserts_single_word" do
    CompleteMe.insert("pizza")
      |> CompleteMe.count()
      |> equal(1)
      |> assert
  end

  test "test_inserts_multiple_words" do
    CompleteMe.populate("pizza\ndog\ncat")
      |> CompleteMe.count()
      |> equal(3)
      |> assert
  end

  test "test_counts_inserted_words" do
    insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
      |> CompleteMe.count()
      |> equal(5)
      |> assert
  end

  test "test_suggests_off_of_small_dataset" do
    trie = insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
      |> CompleteMe.suggest("p")
      |> equal(["pizza"])
      |> assert

    CompleteMe.suggest(trie, "piz")
      |> equal(["pizza"])
      |> assert

    CompleteMe.suggest(trie, "zo")
      |> equal(["zombies"])
      |> assert

    CompleteMe.suggest(trie, "a")
      |> equal(["a", "aardvark"])
      |> assert

    CompleteMe.suggest(trie, "aa")
      |> equal(["aardvark"])
      |> assert
  end

  test "test_inserts_medium_dataset" do
    CompleteMe.populate(medium_word_list())
      
  end
end


# def test_inserts_medium_dataset
#   cm.populate(medium_word_list)
#   assert_equal medium_word_list.split("\n").count, cm.count
# end

# def test_suggests_off_of_medium_dataset
#   cm.populate(medium_word_list)
#   assert_equal ["williwaw", "wizardly"], cm.suggest("wi").sort
# end

# def test_selects_off_of_medium_dataset
#   cm.populate(medium_word_list)
#   cm.select("wi", "wizardly")
#   assert_equal ["wizardly", "williwaw"], cm.suggest("wi")
# end

# def test_works_with_large_dataset
#   cm.populate(large_word_list)
#   assert_equal ["doggerel", "doggereler", "doggerelism", "doggerelist", "doggerelize", "doggerelizer"], cm.suggest("doggerel").sort
#   cm.select("doggerel", "doggerelist")
#   assert_equal "doggerelist", cm.suggest("doggerel").first
# end

# def insert_words(words)
#   cm.populate(words.join("\n"))
# end

# def medium_word_list
#   File.read("./test/medium.txt")
# end

# def large_word_list
#   File.read("/usr/share/dict/words")
# end


