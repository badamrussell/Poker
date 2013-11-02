require 'rspec'
require 'player'
require 'deck'

describe Player do
  subject(:player) { Player.new("Adam", 100) }
  let(:deck) { Deck.new }

  before(:each) do
    player.hand = "A"#deck.take(5)
  end


  its(:name) { should eq "Adam" }
  its(:pot) { should eq(100) }

  context "on a Player's turn" do
    before(:each) {

    }

    it "can discard cards"
    it "can fold"
    it "can raise"
    it "can call"
    it "can check"
  end

end