module Fibonnaci

  def generate(seed0, seed1, n)
    a = seed0
    b = seed1
    while n > 1
      arr = [a, b]
      b = a
      a = fib_iter(arr)
      n -= 1
      puts "%s %s %s" % [a,b,n]
    end
    return a
  end

  def reverse(current, seed0, seed1)
    sequence = []
    n = 0
    this = 0
    until current < this
      this = generate(seed0, seed1, n)
      sequence << this
    end
    return sequence
  end
 
  private
  def fib_iter(arr)
    arr.inject(0,:+)
  end

end

class Generation
  include Fibonnaci
  attr_accessor :pairs

  def initialize(n=2)
    self.pairs = n
  end

  def breed(n_generations=1)
     self.pairs = generate(self.pairs, self.pairs, n_generations)
     return nil
  end
end
