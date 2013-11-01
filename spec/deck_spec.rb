require 'rspec'
require 'deck'

describe Deck do
  let(:deck) { Deck.new }

  it "has 52 cards" do
    deck.size.should be(52)
  end

  it "can have cards removed" do
    deck.draw
    deck.size.should be(51)
  end

  it "can put cards back" do
    card = deck.draw
    deck.replace([card])
    deck.size.should be(52)
  end

end