# -*- coding: utf-8 -*-

require 'rspec'
require 'card'

describe Card do
  subject(:card) { Card.new("♣", "2") }
  let(:card1) { Card.new("♣", "K") }

  it "exists" do
    expect(card).to_not be_nil
  end

  it "has a suit and value" do
    expect(card.suit).to eq("♣")
    expect(card.symbol).to eq("2")
    # expect(card.suit == "♣" && ).to be_true
  end

  it "compares two cards" do
    expect(card < card1).to be_true
  end

end