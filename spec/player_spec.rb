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


    # it "user can input betting action (fold)" do
    #   STDIN.stub(:gets).and_return('fold')
    #
    #   expect(player.ui_action).to eq(:fold)
    # end
    #
    # it "user can input betting action (raise)" do
    #   STDIN.stub(:gets).and_return('raise')
    #
    #   expect(player.ui_action).to eq(:raise)
    # end
    #
    # it "user can input betting action (call)" do
    #   STDIN.stub(:gets).and_return('call')
    #
    #   expect(player.ui_action).to eq(:call)
    # end

    it "user can input raise amount" do
      expect(player.ui_bet).to eq(5)
    end

    it "can place bet (call)" do
      player.stub(:ui_action).and_return(:call)
      expect(player.bet_action(5)).to eq([:call,5,0])
    end

    it "can place bet (raise)" do
      player.stub(:ui_action).and_return(:raise)
      player.stub(:ui_bet).and_return(20)
      expect(player.bet_action(5)).to eq([:raise,5,20])
    end

    it "cannot bet more than he has" do
      player.stub(:ui_action).and_return(:call)
      player.bet_action(300)
    end

    it "can check"
  end


end