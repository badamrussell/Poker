# -*- coding: utf-8 -*-

class Hand

  VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"].reverse

=begin
:r_flush    180
:s_flush    160
:four_kind  140
:full_house 120
:flush      100
:straight   80
:three_kind 80
:two_pair   50  + high_values of both pairs
:one_pair   20 + high_value of pair + 13
:high_card  13
=end

  SETS = [:r_flush, :s_flush, :four_kind, :full_house, :flush, :straight, :three_kind, :two_pair, :one_pair]

  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def size
    self.cards.size
  end

  def sequence
    [].tap do |seq|
      VALUES.each do |value|
        seq[card] << cards.select { |card| card.val == value }
      end
    end
  end

  def best_kind_set
    kinds = num_kind
    return :four_kind if kinds.values.include?(4)
    return :full_house if kinds.values.include?(3) and kinds.values.include?(2)
    return :three_kind if kinds.values.include?(3)
    return :two_pair if kinds.select { |key, val| val == 2 }.size == 2
    return :one_pair if kinds.values.include?(2)
    nil
  end

  def num_kind
    {}.tap do |kinds|
      @cards.each do |card|
        kinds[card.val] = count(card)
      end
    end
  end

  def flush?(suit)
    @cards.all? { |my_card| my_card.suit == suit }
  end

  def straight?
    @cards.sort
  end

  def count(card)
    @cards.select { |my_card| my_card.val == card.val }.size
  end

  def flush()

  end

  def determine_hand
    # if all cards are the same suit
    # :r_flush, :s_flush, :flush

    #check for duplicates
    # :four_kind, :three_kind, :two_pair, :one_pair
    # :full_house

    , :straight,

    SETS = [:r_flush, :s_flush, :four_kind, :full_house, :flush, :straight, :three_kind, :two_pair, :one_pair]

  end
end