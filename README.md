# Find the fastest way to populate a trie of words (using Elixir's awesome concurrency model)

## Backstory
This started off as some programming practice and programming language discovery.I started this repo when I was almost brand new to elixir. I decided to use an assignment from my old bootcamp. see [Assignment](#assignment-completeme).

After messing with Elixir concurrency my focus quickly strayed away from working on the suggestion mechanism and more toward seeing how I could use concurrency to build
the main data structure of the project, a [trie](https://en.wikipedia.org/wiki/Trie) as quickly as possible. The prototypes directory have my first 5 attempts and I had fun learning along the way.

First versions with concurrency involved building separate "machine" processes that did things one at a time and passed their product on to another "machine". Later on,
since the datastructure is basically tree-like I experimented with branching processes. see [TriePopulatorFive](https://github.com/HoffsMH/complete_me/blob/master/lib/prototypes/trie_populator_five/trie_populator_five.ex)

Eventually I

final version is simple


future optimizations
map and inserting smartly


### Lessons learned
#### It can be hard to tell when you are "done"
#### Processes cheap but not free
#### the memory taken up by a single process is important to pay attention to

### more processes dont always improve performance
### ratio between merge and insert

## See it for yourself
### Tests
### Running in iex
#### viewing the data-structure
### Benchmarking
how to run
how to manipulate the benchmark file
different input sizes



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
