require 'rspec'
require 'game'
require 'player'

describe Game do
  subject(:game) { Game.new }
  #let(:player1) { double("player1", name: "Adam", pot: 100) }
  #let(:player2) { double("player2", name: "Hank", pot: 200) }
  let(:player1) { Player.new("Ryan", 100) }
  let(:player2) { Player.new("Christi", 200) }
  let(:player3) { Player.new("Ed", 4) }

  its(:deck) { should be_a(Deck) }

  describe "#start_round" do
    before(:each) do
      game.add_player(player1)
      game.add_player(player2)
      game.add_player(player3)

      game.start_round
    end

    it "has players" do
      expect(game.players.count).to eq(3)
    end

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
    let(:player4) { double("player4", name: "Brian", pot: 100, folded: false) }
    let(:player5) { double("player5", name: "Kiran", pot: 80, folded: false) }
    let(:player6) { double("player6", name: "Prashant", pot: 280, folded: false) }

    before(:each) do
      game.add_player(player4)
      game.add_player(player5)
      game.add_player(player6)
    end

    it "player can fold" do
      player4.stub(:bet_action).with(an_instance_of(Fixnum)) {[:fold, 0, 0]}
      player4.stub(:folded=).with(an_instance_of(TrueClass))
      player5.stub(:bet_action).with(an_instance_of(Fixnum)).and_return([:fold, 0, 0])
      player5.stub(:folded=).with(an_instance_of(TrueClass))
      player6.stub(:bet_action).with(an_instance_of(Fixnum)).and_return([:fold, 0, 0])
      player6.stub(:folded=).with(an_instance_of(TrueClass))

      player4.should_receive(:folded=).with(true)
      game.betting_round
    end

    before(:each) do
      player4.stub(:bet_action).with(an_instance_of(Fixnum)) {[:raise, 0, 20]}
      player5.stub(:bet_action).with(an_instance_of(Fixnum)).and_return([:call, 20, 0])
      player6.stub(:bet_action).with(an_instance_of(Fixnum)).and_return([:call, 20, 0])

      player4.stub(:bet).with(an_instance_of(Fixnum)).and_return(20)
      player5.stub(:bet).with(an_instance_of(Fixnum)).and_return(20)
      player6.stub(:bet).with(an_instance_of(Fixnum)).and_return(20)
    end

    it "players raise and call" do
      player4.should_receive(:bet).with(20)
      player5.should_receive(:bet).with(20)
      player6.should_receive(:bet).with(20)
      game.betting_round
    end

    it "pot accumulates all bets" do
      game.betting_round
      expect(game.pot).to eq(60)
    end

  end

  it "knows whose turn it is"

  it "keeps track of what is in pot"

end