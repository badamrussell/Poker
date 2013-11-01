require 'rspec'
require 'deck'

describe Deck do

  let(:deck_obj) { Deck.new }

  it "has 52 cards" do
    deck_obj.size.should be(52)
  end

  it "can have cards removed" do
    card = deck_obj.draw
    deck_obj.size.should be(51)
    deck_obj.deck.include?(card).should be_false
  end

  it "can put cards back" do
    card = deck_obj.draw
    deck_obj.replace([card])
    deck_obj.size.should be(52)
    deck_obj.deck.include?(card).should be_true
  end
end