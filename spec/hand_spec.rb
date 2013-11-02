# -*- coding: utf-8 -*-
require 'rspec'
require 'hand'

describe Hand do
  let(:cards) { [double("card1", :suit => "♠", :val => "10"),
                 double("card2", :suit => "♠", :val => "J"),
                 double("card3", :suit => "♠", :val => "K"),
                 double("card4", :suit => "♠", :val => "A"),
                 double("card5", :suit => "♠", :val => "Q")] }

  subject(:hand) { Hand.new(cards) }

  its(:is_a?) { Hand }

  its(:size) { should eq 5 }

  its(:pattern) { should eq :royal_flush }

  its(:hand_value) { should eq 100 }
end


