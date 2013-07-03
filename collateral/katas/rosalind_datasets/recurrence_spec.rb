require 'rspec'
require './Recurrence_Relations'


describe 'Rabbits' do
  it 'breed for n months at k new pairs per pair' do
    rabbits = Rabbits.new(3).
      breed(5).
      count.should eq 19
  end

  it 'die after m months' do
    rabbits = Rabbits.new(1,3).
      breed(6).
      count.should eq 4
  end
end
