# -*- coding: utf-8 -*-
require 'rspec'
require 'hand'

describe Hand do
  let(:cards) { [double("card1", :suit => "♠", :symbol => "10", :value => 10),
                 double("card2", :suit => "♠", :symbol => "J", :value => 11),
                 double("card3", :suit => "♠", :symbol => "K", :value => 13),
                 double("card4", :suit => "♠", :symbol => "A", :value => 14),
                 double("card5", :suit => "♠", :symbol => "Q", :value => 12)] }
                 card_set = [Card.new("♠","10"), Card.new("♠","J"), Card.new("♠","K"), Card.new("♠","A"), Card.new("♠","Q")]

  #subject(:hand) { Hand.new(cards) }
  subject(:hand) { Hand.new(card_set) }
  its(:is_a?) { Hand }

  its(:size) { should eq 5 }

  its(:straight?) { should be_true }
  its(:flush?) { should be_true }

  its(:pattern) { should eq :royal_flush }

  its(:hand_value) { should eq 100 }
end


