require 'rspec'
require 'game'

describe Game do
  subject(:game) { Game.new }

  its(:deck) {should be_true }

  it "has a deck"

  it "has players"

  it "knows whose turn it is"

  it "keeps track of what is in pot"

end