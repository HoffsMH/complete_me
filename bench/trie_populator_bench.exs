defmodule TriePopulateBench do
  use Benchfella
  @list Enum.to_list(1..1000)

  bench "hello list" do
    Enum.reverse @list
  end

  def medium_word_list do
    File.read("./test/medium.txt")
  end
end
