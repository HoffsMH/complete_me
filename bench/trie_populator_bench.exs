defmodule TriePopulateBench do
  use Benchfella
  @tp TriePopulator
  @tp2 TriePopulatorTwo
  @list Enum.to_list(1..1000)

  bench "hello list" do
    Enum.reverse @list
  end

  bench "Medium List Naive" do
    with {:ok, medium_text} <- medium_word_list()
    do
      @tp.populate(medium_text)
    end
  end

  bench "Large List Naive" do
    with {:ok, large_text} <- large_word_list()
    do
      @tp.populate(large_text)
    end
  end

  bench "Medium List two" do
    with {:ok, medium_text} <- medium_word_list()
    do
      @tp2.populate(medium_text)
    end
  end

  bench "Large List two" do
    with {:ok, large_text} <- large_word_list()
    do
      @tp2.populate(large_text)
    end
  end

  def medium_word_list do
    File.read("./test/medium.txt")
  end

  def large_word_list do
    File.read("/usr/share/dict/words")
  end
end
