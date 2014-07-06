---
layout: post
title: "A Better Fibonacci (Revisited)"
date: 2013-05-25
categories:
  - mathematics
  - recursion
  - sequences
preview: short comparison between recursive, iterative, and analytic implementations of the Fibonacci sequence
---

[Previously](https://coderwall.com/p/_vou1q), I posted a non-recursive algorithm to compute an arbitrary Fibonacci number:

    PHI = 1.6180339887498948482045868
    const_fib = lambda do |n|
      (
        ( PHI**n - ( 1 - PHI )**n ) /
        Math.sqrt(5)
      ).
      floor
    end

Since the mathematical constant PHI is an infinite, non-repeating decimal, it can never be exactly represented in code. Indeed, the Fibonacci series computed by the above code and the exact series diverge after only the 70th value.

    computed = []
    (1..1474).each { |n| computed << const_fib[n].to_s }
    
    # list of Fibonnaci number can be downloaded from http://oeis.org/A000045/b000045.txt
    exact = []
    File.open('./exact.txt', 'r').each_line do |line|
      exact << line.split.last
    end
    
    exact.shift # the first entry on the downloaded list is zero, get rid of it
    
    index_of_last_match = (computed & exact).size
    #=> 70
    
    computed[index_of_last_match] == exact[index_of_last_match]
    #=> true
    
    computed[index_of_last_match + 1] == exact[index_of_last_match + 1]
    #=> false

When I first hacked at this hackneyed code exercise, I assumed using the constant PHI would still be more efficient than a loop or a recursive algorithm. Turns out, modern hardware make the loop-based solution quite tolerable.

    loop_fib = lambda do |n|
      fib = []
      n.times do |n|
        if n < 2
          fib = [0, 1, 1]
        else
          fib << ( fib[-1] + fib[-2] ).to_s
        end
      end
      return fib.last
    end
    
    loop_fib[70] == exact[70]
    #=> true

    loop_fib[71] == exact[71]
    #=> true

My computer hardly notices. How about the recursive method?

    recur_fib = lambda do |n|
      case n
      when 0
        1
      when 1
        1
      else
        recur_fib[n - 1] + recur_fib[n - 2]
      end
    end
    
    recur_fib[70]

Beautiful math; horrifying code! Running it quickly ate up my memory and swap space.

I'm going to pose a challenge for readers here. Read section 1.2.1 in [*Structure and Interpretation of Computer Programs*](https://mitpress.mit.edu/sicp/full-text/book/book-Z-H-11.html#%_sec_1.2.1) for a much more reasonable recursive template, and try combining the approach in that book with the first algorithm above. Specifically, pack your recursion into a separate function that computes an arbitrary precision value for PHI. Can we get const_fib to run faster and more efficiently than loop_fib?
