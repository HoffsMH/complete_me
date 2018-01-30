# CompleteMe 
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

