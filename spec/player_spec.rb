require 'rspec'
require 'player'

describe Player do
  subject(:player) { Player.new(100) }

  its(:pot) { should eq(100) }

  it "can get a new hand"

  it "can return cards from hand"

  context "with User Input" do
    it "can discard cards"
    it "can fold"
    it "can raise"
  end

end