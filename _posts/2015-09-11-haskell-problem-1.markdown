---
layout: post
title: "haskell problem 1"
date: 2015-09-11 00:00:00
categories:
  - lessons
  - haskell
preview: find the last item in a list
---

1. tools:
  - another installation is the [official platform](https://www.haskell.org/platform/)
  - once you have a working installation, the program `ghci` launches the interactive repl

2. resources:
  - no new ones today

3. tricks / techniques:
  - the solution below follows the standard sourcefile construction of Haskell code. but we can define functions "on the fly" by using the `let { }` constructor

4. solutions:
- as a sourcefile:

<!-- the markdown engine is not handling the Haskell code well -->
<pre><code>myLast :: [a] -> a
myLast []     = error "empty list"
myLast [x]    = x
myLast (_:xs) = myLast xs</code></pre>

- dynamically in GHCi:

<pre><code>let {
  myLast2 []     = error "empty list"
  myLast2 [x]    = x
  myLast2 (_:xs) = myLast2 xs
}</code></pre>
So the main (casual) observation is that a function has two components: the type declaration and the function implementation. When writing source code, the type declaration is required; when dynamically creating a function in the repl, the compiler infers the type signature from its definition. The function implementation mechanically works via pattern matching -- a very powerful concept that we'll eventually get around to learning in depth. Otherwise, a good first exercise!
