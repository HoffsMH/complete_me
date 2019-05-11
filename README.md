# Find the fastest way to populate a trie of words (using Elixir's awesome concurrency)

This started off as some programming practice and programming language discovery. I started this project relatively new to elixir and worked on it on and off in my spare time. It started as an interest in an assignment from my old coding bootcamp. see [Assignment](#assignment-completeme).

After getting the initial version running my focus quickly strayed away from working on the suggestion mechanism of the assignment and more toward seeing how I could use concurrency to build the main data structure of the project, a [trie](https://en.wikipedia.org/wiki/Trie), as quickly as possible. The [prototypes](https://github.com/HoffsMH/complete_me/tree/master/lib/prototypes) directory has the first 5 versions of my [TriePopulator](https://github.com/HoffsMH/complete_me/blob/master/lib/trie_populator.ex) and I had fun learning along the way!

The first versions involved building separate "machine" processes that did things one at a time and passed their product on to another "machine".

Later on I experimented with branching processes, since the datastructure is tree-like anyway. See [TriePopulatorFive](https://github.com/HoffsMH/complete_me/blob/master/lib/prototypes/trie_populator_five/trie_populator_five.ex)

The final (and best performing as input grows) version is actually much simpler than most of the first 5 attempts. It chunks the list
of words into a set amount of "portions", with a minimum amount of "portions" being enforced by a maximum portion size. It then makes processes for turning
each of those portions into a trie and then merges all tries at the end within a single process. I experimented with merging in separate processes as well but couldn't reach the same performance with that method.


Heres what the benchmarks for the various versions looks like on my machine (i7 macbook late 2015)

1000 word list:

```
Name                                  ips        average  deviation         median         99th %
trie_pop_6_with_7_portions         512.27        1.95 ms     ±8.28%        1.92 ms        2.45 ms
trie_pop_6_with_10_portions        509.88        1.96 ms     ±9.17%        1.94 ms        2.44 ms
trie_pop_6_with_8_portions         493.39        2.03 ms    ±12.73%        1.98 ms        2.79 ms
trie_pop_6_with_5_portions         485.64        2.06 ms     ±9.88%        2.04 ms        2.63 ms
trie_pop_6_with_9_portions         485.28        2.06 ms     ±8.94%        2.04 ms        2.61 ms
trie_pop_6_with_6_portions         479.39        2.09 ms     ±9.10%        2.08 ms        2.63 ms
trie_pop_6_with_4_portions         440.86        2.27 ms     ±9.48%        2.31 ms        2.79 ms
trie_pop_6_with_3_portions         436.81        2.29 ms     ±7.65%        2.35 ms        2.72 ms
trie_pop_1                         247.51        4.04 ms    ±23.74%        4.04 ms        7.58 ms
trie_pop_2                          58.57       17.07 ms    ±14.67%       16.29 ms       28.82 ms
trie_pop_5                          46.06       21.71 ms     ±2.94%       21.58 ms       23.83 ms
trie_pop_3                          22.86       43.74 ms    ±11.96%       43.62 ms       55.99 ms
trie_pop_4                          16.31       61.32 ms     ±3.35%       61.11 ms
```

250k word list:
```
Name                                  ips        average  deviation         median         99th %
trie_pop_6_with_9_portions           2.66      376.03 ms     ±9.78%      371.48 ms      434.79 ms
trie_pop_6_with_4_portions           2.50      399.56 ms    ±10.09%      398.06 ms      466.59 ms
trie_pop_6_with_8_portions           2.40      416.36 ms    ±16.42%      411.44 ms      606.71 ms
trie_pop_6_with_7_portions           2.35      426.42 ms    ±15.57%      419.21 ms      575.55 ms
trie_pop_6_with_5_portions           2.33      428.51 ms    ±15.14%      399.29 ms      584.93 ms
trie_pop_6_with_10_portions          2.27      440.12 ms    ±15.69%      450.12 ms      536.83 ms
trie_pop_6_with_3_portions           2.05      487.96 ms    ±37.20%      459.03 ms      904.93 ms
trie_pop_6_with_6_portions           2.05      488.25 ms    ±15.05%      497.93 ms      614.52 ms
trie_pop_5                           0.52     1928.11 ms     ±7.32%     1967.24 ms     2045.62 ms
trie_pop_1                           0.39     2588.03 ms     ±1.76%     2588.03 ms     2620.23 ms
```

There are probably still many optimizations that can be made and I will continue to chip away at this as I learn more about tuning performance in elixir :)

### Some lessons learned
#### It can be hard to tell when you are "done" with a task if you fail to keep track of all the processes you spawn in service of that task.
Some of the tests for the attempts 2-4 are now skipped due to some slight flakiness. The reason for this is that I built them in a way
that the module has a hard time telling when it is "done" with all jobs

For instance in some of my attempts there are a series of "machine" processes:
There is a machine process taking words from the list of all words and spinning off many child processes that will turn the words into standalone tries and putting them in a stack of tries
There is a machine process that checks the stack of tries to see if there is more than one and if there is it creates a child process that will merge them and put the result back into the stack of tries.
Both of these run concurrently

The problem here is that my condition for detecting when all words are in a single trie is now something like

```
if there are no more words in the word list
and there is only one trie in the trie list
and there are no more active jobs turning words into tries
and there are no more active jobs merging tries
```

I never fully figured out what was causing these modules to produce incorrect tries and moved on to a better method
in TriePopulator 5 and 6

#### Processes are cheap but their memory is not.
Sure its not that much of a problem to spawn `10_000` processes if each one is empty. But if each one contains a copy of a non-trivial data structure that it will be manipulating it can get expensive on memory very quickly.

#### There is a ratio to keep between expensive and cheap operations, rather than just attempting to do everything in paralell.
Attempting to make 250k separate tries for each word is something like 250k * the length of the average word in terms of map writes. Then when merging them
you have to perform basically the exact same set of of 250k words worth of map writes again. So even though there is an advantage to doing things this way in that you
can do all of these writes in paralell, the total operation still performs much more poorly than just creating a single trie, word by word, within a single process because you have basically doubled your most expensive operation. And at the end of the day you don't have 1k cpu cores at your disposal :(

I guess If I had to abstract this lesson into something more general: sometimes it might be possible to paralellize a task at the cost of adding a more total work, special attention needs to be payed to how much extra work is actually being generated.

## See it for yourself
### Tests
You should be able to run tests with

```sh
mix test
```

#### viewing the data-structure in iex
```Elixir
trie = CompleteMe.populate(File.read!("/usr/share/dict/words"))
CompleteMe.suggest(trie, "cat")
# ["cate", "catan", "catch", "cater", "catty", "catchy", "catdom", "catena",
# "cateye", "catgut", "cathin", "cathop", "cathro", "cation", "cativo", "catkin",
# "catlap", "catlin", "catnip", "catsup", "cattle", "catalpa", "catapan",
```

### Benchmarking
Benchmarks can be run with
```sh
mix run bench/trie_populator.exs
```

Different parts of the benchmark file can be commented and uncommented to try different input sizes and different trie populator versions


The following is the material for the assignment:

# Assignment: CompleteMe
[from turing project page](http://backend.turing.io/module1/projects/complete_me)

Everyone in today’s smartphone-saturated world has had their share of interactions with textual “autocomplete.” You may have sometimes even wondered if autocomplete is worth the trouble, given the ridiculous completions it sometimes attempts.

But how would you actually make an autocomplete system?

In this project, CompleteMe we’ll be exploring this idea by a simple textual autocomplete system. Perhaps in the process we will develop some sympathy for the developers who built the seemingly incompetent systems on our phones…

### Tries
A common way to solve this problem is using a data structure called a Trie. The name comes from the idea of a Re-trie-val tree, and it’s useful for storing and then fetching paths through arbitrary (often textual) data.

A Trie is somewhat similar to the binary trees you may have seen before, but whereas each node in a binary tree points to up to 2 subtrees, nodes within our retrieval tries will point to N subtrees, where N is the size of the alphabet we want to complete within.

Thus for a simple latin-alphabet text trie, each node will potentially have 26 children, one for each character that could potentially follow the text entered thus far. (In graph theory terms, we could classify this as a Directed, Acyclic graph of order 26, but hey, who’s counting?)

What we end up with is a broadly-branched tree where paths from the root to the leaves represent “words” within the dictionary.

Take a moment and read more about Tries:

[Tries writeup in the DSA Repo](https://github.com/turingschool/data_structures_and_algorithms/tree/master/tries)
[Tries Wikipedia Article](https://en.wikipedia.org/wiki/Trie)

### Input File
Of course, our Trie won’t be very useful without a good dataset to populate it. Fortunately, our computers ship with a special file containing a list of standard dictionary words. It lives at /usr/share/dict/words

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `complete_me` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:complete_me, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/complete_me](https://hexdocs.pm/complete_me).
