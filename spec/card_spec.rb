# -*- coding: utf-8 -*-

require 'rspec'
require 'card'

describe Card do
  let(:card) { Card.new }

  it "exists" do
    expect(card).to_not be_nil
  end

  it "has a suit and value" do
    card = Card.new("♣", "A")
    expect(card.suit).to eq("♣")
    expect(card.val).to eq("A")
    # expect(card.suit == "♣" && ).to be_true
  end



end