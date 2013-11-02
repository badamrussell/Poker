require 'rspec'
require 'game'
require 'player'

describe Game do
  subject(:game) { Game.new }
  #let(:player1) { double("player1", name: "Adam", pot: 100) }
  #let(:player2) { double("player2", name: "Hank", pot: 200) }
  let(:player1) { Player.new("Adam", 100) }
  let(:player2) { Player.new("Hank", 200) }
  let(:player3) { Player.new("Bill", 4) }

  its(:deck) { should be_a(Deck) }

  before(:each) do
    game.add_player(player1)
    game.add_player(player2)
    game.add_player(player3)
    player3.folded = true
  end

  it "has players" do
    expect(game.players.count).to eq(3)
  end

  describe "#start_round" do
    before(:each) { game.start_round }

    it "all players ante up" do
      expect(player1.pot).to eq(95)
      expect(player2.pot).to eq(195)
    end

    it "all players have 5 cards" do
      expect(player1.hand.count).to eq(5)
      expect(player2.hand.count).to eq(5)
    end

    it "antes added to pot" do
      expect(game.pot).to eq(10)
    end


  end

  describe "#betting_round" do

    it "player can fold"

    it "player raises"

    it "player calls"

    it "player checks"

    it "after raise, other plays must match"
  end

  it "knows whose turn it is"

  it "keeps track of what is in pot"

end