require 'rspec'
require 'deck'

describe Deck do

  subject(:deck) { Deck.new }

  it "has 52 cards" do
    deck.size.should be(52)
  end

  it "can have cards removed" do
    card = deck.draw
    deck.size.should be(51)
    deck.deck.include?(card).should be_false
  end

  it "can put cards back" do
    card = deck.draw
    deck.replace([card])
    deck.size.should be(52)
    deck.deck.include?(card).should be_true
  end
end