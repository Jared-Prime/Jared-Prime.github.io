---
layout: post
title: "Simple and Lovely"
date: 2013-07-13
categories: algorithms
preview: simple exposition of some toy algorithms
---

Simple is beautiful, and because simple atomic, code, when composed with other simple, atomic chunks of code, has the potential to express quite a bit of complexity.

Here is a perennial favorite. The rules are expressed as comments in the code itself

    fizzbuzz = lambda do |n|
      if n % 5 == 0 && n % 3 == 0
        # Rule 3 - if n is divisible by both 3 and 5, say "fizzbuzz"
        n = :fizzbuzz
      elsif n % 5 == 0
        # Rule 2 - if n is divisible by 5, say "buzz"
        n = :buzz
      elsif n % 3 == 0
        # Rule 1 - if n is divisible by 3, say "fizz"
        n = :fizz
      else
        # Rule 4 - otherwise, say n
        n = n
      end
      return n
    end

Now, let's say we want to transform a range or an array of numbers into its fizzy-buzzy equivalent.

    fizzbuzz_sequence = lambda do |seq|
      seq.map{|n| fizzbuzz.call n }
    end

The next example is written in JavaScript,

    function divide(array, k) {
      // divide an array at position k from the tail
      if(array === undefined || array === null){ return null }

      var head = array, // we want to preserve the original array
          tail = [],
          end;

      for(var i=0; i<k; i++){
        end = head.pop();
        if(end !== undefined){ tail.unshift(end) }
      }
      return {"head":head, "tail":tail};
    }

One could just as easily go from the other direction (I just thought cutting from the tail was more interesting). Just swap "head" with "tail" to get the same results.
