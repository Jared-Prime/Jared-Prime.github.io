---
layout: post
title: "Using the Pry Repl"
date: 2013-08-12
categories:
  - algorithms
  - tools
preview: playing around with a new(ish) tool
---

Many Ruby programmers are introduced to the language via the built-in "interactive Ruby" environment, or irb. The irb is a read, evaluate, print loop (aka REPL) which allows the programmer to modify her code dynamically during development, seeing results in real time. But irb is not the only Ruby REPL out there; pry in particular has become my favorite.

Install pry as you would any other gem, <code>gem install pry</code>, and place any customizations in <code>~/.pryrc</code> (global) or just <code>.pryrc</code> (current directory only) as a Ruby script. From there, you can use pry just like irb, or you could do something a bit more interesting.

Here's the sample code I'm working with, my hobby-horse, an implementation of the Fibonacci series.

    class Fib

      attr_accessor :past, :prev, :current

      def initialize
        @past    = 0
        @prev    = 1
        @current = 1

        @cache = [@past, @prev, @current]
      end

      def next
        @past    = @prev
        @prev    = @current
        @current = @past + @prev
        @cache  << @current
        return self
      end

      def size
        @cache.size
      end

      def find(n)
        (n - size + 1).times{ self.next } unless @cache[n]
        @cache[n]
      end

    end

I'm pasting this directly into pry to evaluate the algorithm.

    >> class Fib
     |
     |   attr_accessor :past, :prev, :current
     |
     |   def initialize
     |     @past    = 0
     |     @prev    = 1
     |     @current = 1
     |
     |     @cache = [@past, @prev, @current]
     |   end
     |
     |   def next
     |     @past    = @prev
     |     @prev    = @current
     |     @current = @past + @prev
     |     @cache  << @current
     |     return self
     |   end
     |
     |   def size
     |     @cache.size
     |   end
     |
     |   def find(n)
     |     (n - size + 1).times{ self.next } unless @cache[n]
     |     @cache[n]
     |   end
     |
     | end
    => nil

Cool. Everything is familiar so far, except you'll notice your console has some pretty colors! Grab the tenth Fibonacci for illustration.

    >> f = Fib.new
    => #<Fib:0x007fa35c4c58e0 @cache=[0, 1, 1], @current=1, @past=0, @prev=1>
    >> f.find(10)
    => 55
    >> f
    => #<Fib:0x007fa35c4c58e0
     @cache=[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55],
     @current=55,
     @past=21,
     @prev=34>

Again, all familiar output, similar to irb. Now let's do something cool:

    >> cd f
    >> ls
    Fib#methods:
      a   b   c   current   d   find  next  past=  prev=
      a=  b=  c=  current=  d=  fold  past  prev   size
    self.methods: __pry__
    instance variables: @cache  @current  @past  @prev
    locals: _  __  _dir_  _ex_  _file_  _in_  _out_  _pry_

We just used the Unix <code>cd</code> command to "navigate" "inside" the object <code>f</code>, then used <code>ls</code> to display the object's class level methods, instance variables, as well as the REPL's own local variables.

We can go deeper, say, into the object's own instance variables:

    >> cd @cache
    >> ls
    Enumerable#methods:
      all?            each_entry        find_all  max      minmax_by     sort_by
      any?            each_slice        flat_map  max_by   none?         to_set
      chunk           each_with_index   grep      member?  one?
      collect_concat  each_with_object  group_by  min      partition
    Enumerable#methods:
      all?            each_entry        find_all  max      minmax_by     sort_by
      any?            each_slice        flat_map  max_by   none?         to_set
      chunk           each_with_index   grep      member?  one?
      collect_concat  each_with_object  group_by  min      partition
      detect          entries           inject    min_by   reduce
      each_cons       find              lazy      minmax   slice_before
    Array#methods:
      &            count       include?            reject!               slice!
      *            cycle       index               repeated_combination  sort
      +            delete      insert              repeated_permutation  sort!
      -            delete_at   inspect             replace               sort_by!
      <<           delete_if   join                reverse               take
      <=>          drop        keep_if             reverse!              take_while
      ==           drop_while  last                reverse_each          to_a
      []           each        length              rindex                to_ary
      []=          each_index  map                 rotate                to_s
      assoc        empty?      map!                rotate!               transpose
      at           eql?        pack                sample                uniq
      bsearch      fetch       permutation         select                uniq!
      clear        fill        pop                 select!               unshift
      collect      find_index  pretty_print        shelljoin             values_at
      collect!     first       pretty_print_cycle  shift                 zip
      combination  flatten     product             shuffle               |
      compact      flatten!    push                shuffle!
      compact!     frozen?     rassoc              size
      concat       hash        reject              slice
    self.methods: __pry__
    locals: _  __  _dir_  _ex_  _file_  _in_  _out_  _pry_
    >>

A lightbulb ought to shine bright here. You've likely come across a situation where you needed to know which methods were available after calling a some other method. Now it's easy as

    >> cd f.size
    >> ls
    Comparable#methods: between?
    Numeric#methods:
      +@      conj       imaginary     pretty_print_cycle  rectangular
      abs2    conjugate  nonzero?      quo                 remainder
      angle   eql?       phase         real                singleton_method_added
      arg     i          polar         real?               step
      coerce  imag       pretty_print  rect                to_c
    Integer#methods:
      ceil         downto  gcdlcm    next       pred         times  to_int    upto
      chr          floor   integer?  numerator  rationalize  to_bn  to_r
      denominator  gcd     lcm       ord        round        to_i   truncate
    Fixnum#methods:
      %  **  -@  <<   ==   >=  ^        div     fdiv       modulo  succ  zero?
      &  +   /   <=   ===  >>  __pry__  divmod  inspect    odd?    to_f  |
      *  -   <   <=>  >    []  abs      even?   magnitude  size    to_s  ~
    locals: _  __  _dir_  _ex_  _file_  _in_  _out_  _pry_

Above we called <code>Fib#size</code> to see how many numbers are in the object's cache. Since the method returns an integer, the methods that we can chain off <code>Fib#size</code> are only those that pertain to <code>Integer</code>. Simple concept, but profound discovery via the pry REPL!
