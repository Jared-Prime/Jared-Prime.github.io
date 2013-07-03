class Rabbits

  def initialize(birthrate=1, lifespan=1_000_000)
    @population = []
    @lifespan   = lifespan
    @birthrate  = birthrate
  end

  def breed(months)
    months.times do |month|
      if month < 1
        current = 1
      else
        current = count + breeding
      end
      @population << current
      puts dying
    end
    return self
  end

  def count
    @population[-1].to_i
  end

  def breeding
    @population[-2].to_i * @birthrate
  end

  def dying
    @population[-3].to_i
  end

end
