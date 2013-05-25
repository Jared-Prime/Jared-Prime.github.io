class DictionaryKata < Array

  # we cheat, knowing how many characters we have to match
  def initialize(word_size)
    File.open("/usr/share/dict/words","r") do |words|
      words.each do |word|
        word.gsub!(/\n/,'')
        self << word if word.size == word_size
      end
    end
  end

  def word_chain(word="cat", step=0)
    
    # this case statement only makes sense
    # with the foreknowledge that "cat" has 3 letters
    if step < 1
      # preserve interior of the word
      head = word[0]
      tail = word[-1]
      part = /^#{head}.#{tail}$/
    else
      # match the heads of the first result set
      head = word[0..step]
      part = /^#{head}/
      # match the tails of the second result set
      tail = word[-(step+1)..-1]
      part = /#{tail}$/
    end

    # return everything from the dictionary that matches
    self.select { |word| word.match(part) }
  end

end

# run a script for the results
step = 0
node0 = "cat"
dictionary = DictionaryKata.new(3)
dictionary.word_chain(node0,step).each do |node1|
  dictionary.word_chain(node1,step+1).each do |node2|
    puts "%s => %s => %s => dog" % [node0, node1, node2] if dictionary.word_chain(node2,step+2).include?("dog")
  end
end

