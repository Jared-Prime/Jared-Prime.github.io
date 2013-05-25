String.class_eval do

  def sequence
    sequence = {'A' => 0, 'C' => 0, 'G' => 0, 'T' => 0}
    self.each_char do |char|
      sequence[char] += 1
    end
    return sequence
  end

  def nucleotide_count
    self.sequence.values.join(' ')
  end

  def reverse_complement
    rc = ""
    self.reverse!
    self.each_char do |char|
      case char
      when 'A'
        rc += 'T'
      when 'T'
        rc += 'A'
      when 'G'
        rc += 'C'
      when 'C'
        rc += 'G'
      end
    end
    return rc
  end

end

puts dna.nucleotide_count
