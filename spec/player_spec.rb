require 'rspec'
require 'player'
require 'deck'

describe Player do
  subject(:player) { Player.new("Adam", 100) }
  let(:deck) { Deck.new }

  before(:each) do
    player.hand = deck.draw(5)
  end

  its(:name) { should eq "Adam" }
  its(:pot) { should eq(100) }


  context "player's turn" do


    it "can fold" do
      player.stub(:ui_action).and_return(:fold)

      expect(player.bet_action(5)).to eq([:fold,0,0])
    end

    it "can place bet (raise/call/ante)"


    it "can check"
  end

end