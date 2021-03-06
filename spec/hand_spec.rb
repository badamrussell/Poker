# -*- coding: utf-8 -*-
require 'rspec'
require 'hand'
require 'card'

describe Hand do
  # let(:c_10s) { double("card1", :suit => "♠", :symbol => "10", :value => 10) }
  # let(:c_Js) { double("card2", :suit => "♠", :symbol => "J", :value => 11) }
  # let(:c_Ks) { double("card3", :suit => "♠", :symbol => "K", :value => 13) }
  # let(:c_As) { double("card4", :suit => "♠", :symbol => "A", :value => 14) }
  # let(:c_Qs) { double("card5", :suit => "♠", :symbol => "Q", :value => 12) }
  let(:c_10s) { Card.new("♠","10") }
  let(:c_Js) { Card.new("♠","J") }
  let(:c_Ks) { Card.new("♠","K") }
  let(:c_As) { Card.new("♠","A") }
  let(:c_Qs) { Card.new("♠","Q") }

  let(:card_set) { [c_10s, c_Js, c_Ks, c_As, c_Qs] }

  subject(:hand) { Hand.new([c_10s, c_Js, c_Ks, c_As, c_Qs]) }
  its(:is_a?) { Hand }

  its(:size) { should eq 5 }

  its(:straight?) { should be_true }
  its(:flush?) { should be_true }

  describe "#discard" do
    it "should discard a card" do
      hand.discard([c_10s, c_Qs])
      expect(hand.cards).to eq([c_Js, c_Ks, c_As])
    end

    it "should not allow you to discard too many cards" do
      expect do
        hand.discard([c_Js, c_Ks, c_As, c_10s, c_Qs, c_10s])
      end.to raise_error("cannot discard that many cards")
    end
  end

  # describe "#draw" do
  #   hand.draw(1)
  #   expect(hand.count).to eq(5)
  # end

  describe "#names" do
    it "royal flush" do
      card_set1 = [Card.new("♠","10"), Card.new("♠","J"), Card.new("♠","K"), Card.new("♠","A"), Card.new("♠","Q")]
      hand1 = Hand.new(card_set1)
      expect(hand1.name).to be(:r_flush)
    end

    it "straight flush" do
      card_set1 = [Card.new("♠","10"), Card.new("♠","J"), Card.new("♠","K"), Card.new("♠","9"), Card.new("♠","Q")]
      hand1 = Hand.new(card_set1)
      expect(hand1.name).to be(:s_flush)
    end

    it "flush" do
      card_set1 = [Card.new("♠","3"), Card.new("♠","J"), Card.new("♠","7"), Card.new("♠","9"), Card.new("♠","Q")]
      hand1 = Hand.new(card_set1)
      expect(hand1.name).to be(:flush)
    end

    it "four of a kind" do
      card_set1 = [Card.new("♣","J"), Card.new("♦","J"), Card.new("♥","J"), Card.new("♠","J"), Card.new("♠","Q")]
      hand1 = Hand.new(card_set1)
      expect(hand1.name).to be(:four_kind)
    end

    it "three of a kind" do
      card_set1 = [Card.new("♣","J"), Card.new("♦","J"), Card.new("♥","J"), Card.new("♠","A"), Card.new("♠","Q")]
      hand1 = Hand.new(card_set1)
      expect(hand1.name).to be(:three_kind)
    end

    it "full house" do
      card_set1 = [Card.new("♣","J"), Card.new("♦","J"), Card.new("♥","J"), Card.new("♠","Q"), Card.new("♣","Q")]
      hand1 = Hand.new(card_set1)
      expect(hand1.name).to be(:full_house)
    end

    it "two pair" do
      card_set1 = [Card.new("♣","J"), Card.new("♦","J"), Card.new("♥","5"), Card.new("♠","Q"), Card.new("♣","Q")]
      hand1 = Hand.new(card_set1)
      expect(hand1.name).to be(:two_pair)
    end

    it "one pair" do
      card_set1 = [Card.new("♣","J"), Card.new("♦","J"), Card.new("♥","5"), Card.new("♠","8"), Card.new("♣","Q")]
      hand1 = Hand.new(card_set1)
      expect(hand1.name).to be(:one_pair)
    end

    it "high_card" do
      card_set1 = [Card.new("♣","J"), Card.new("♦","5"), Card.new("♥","7"), Card.new("♠","2"), Card.new("♣","Q")]
      hand1 = Hand.new(card_set1)
      expect(hand1.name).to be(:high_card)
    end
  end


  describe "#beats?" do
    it "four of a kind beats flush" do
      card_set1 = [Card.new("♠","3"), Card.new("♠","J"), Card.new("♠","7"), Card.new("♠","9"), Card.new("♠","Q")]
      hand1 = Hand.new(card_set1)
      card_set2 = [Card.new("♣","J"), Card.new("♦","J"), Card.new("♥","J"), Card.new("♠","J"), Card.new("♠","Q")]
      hand2 = Hand.new(card_set2)

      expect(hand2.beats?(hand1)).to be_true
    end

    it "flush loses to full house" do
      card_set1 = [Card.new("♠","3"), Card.new("♠","J"), Card.new("♠","7"), Card.new("♠","9"), Card.new("♠","Q")]
      hand1 = Hand.new(card_set1)
      card_set2 = [Card.new("♣","J"), Card.new("♦","J"), Card.new("♥","J"), Card.new("♠","Q"), Card.new("♣","Q")]
      hand2 = Hand.new(card_set2)

      expect(hand1.beats?(hand2)).to be_false
    end

    describe "handles ties" do
      it "2 pairs (3,7) & (J,6)" do
        card_set1 = [Card.new("♠","3"), Card.new("♦","3"), Card.new("♥","7"), Card.new("♠","7"), Card.new("♠","Q")]
        hand1 = Hand.new(card_set1)
        card_set2 = [Card.new("♣","J"), Card.new("♦","J"), Card.new("♥","6"), Card.new("♠","6"), Card.new("♣","Q")]
        hand2 = Hand.new(card_set2)

        expect(hand1.beats?(hand2)).to be_false
      end
      it "2 pairs with hi-card (3,7 > Q) & (3,7 > A)" do
        card_set1 = [Card.new("♠","3"), Card.new("♦","3"), Card.new("♥","7"), Card.new("♠","7"), Card.new("♠","Q")]
        hand1 = Hand.new(card_set1)
        card_set2 = [Card.new("♣","3"), Card.new("♥","3"), Card.new("♣","7"), Card.new("♦","7"), Card.new("♣","A")]
        hand2 = Hand.new(card_set2)

        expect(hand2.beats?(hand1)).to be_true
      end

      it "2 flushes (Q) & (A)" do
        card_set1 = [Card.new("♠","3"), Card.new("♠","4"), Card.new("♠","10"), Card.new("♠","7"), Card.new("♠","Q")]
        hand1 = Hand.new(card_set1)
        card_set2 = [Card.new("♥","A"), Card.new("♥","J"), Card.new("♥","2"), Card.new("♥","6"), Card.new("♥","10")]
        hand2 = Hand.new(card_set2)

        expect(hand1.beats?(hand2)).to be_false
      end

      it "2 straights (lo-A) and (hi-A)" do
        card_set1 = [Card.new("♠","A"), Card.new("♠","2"), Card.new("♥","3"), Card.new("♠","4"), Card.new("♠","5")]
        hand1 = Hand.new(card_set1)
        card_set2 = [Card.new("♥","10"), Card.new("♥","J"), Card.new("♦","Q"), Card.new("♥","K"), Card.new("♥","A")]
        hand2 = Hand.new(card_set2)

        expect(hand1.beats?(hand2)).to be_false
      end
    end
  end

  describe "during the draw phase" do

#     it "can select cards" do
#       STDIN.stub(:gets).and_return('1,2,3')
#       expect(hand.select_cards).to eq([c_10s, c_Js, c_Ks])
#     end

    it "can discard cards"

    it "can draw cards"
  end

end


