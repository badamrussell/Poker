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

  SETS = [:r_flush, :s_flush, :four_kind, :full_house, :flush, :straight, :three_kind, :two_pair, :one_pair, :high_card]

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


  def find_kinds
    {}.tap do |kinds|
      @cards.each do |card|
        kinds[card.symbol] = count(card)
      end
    end
  end

  def flush?(suit)
    @cards.all? { |my_card| my_card.suit == suit }
  end

  def high_card
    best_card = cards[0]
    @cards.each do |card|
      best_card = card if card.value > best_card.value
    end
    best_card
  end

  def straight?
    diff = 0
    @cards.sort!.reverse!
    (0...(@cards.size - 1)).each do |index|
      diff += (@cards[index].value - @cards[index+1].value).abs
    end

    diff == 4
  end

  def count(card)
    @cards.select { |my_card| my_card.symbol == card.symbol }.size
  end

  def flush?
    suit = @cards[0].suit
    @cards.select { |my_card| my_card.suit == suit }.size == 5
  end

  def find_flush_hand
    return :high_card unless flush?
    return :flush unless straight?
    return :r_flush if high_card.symbol == "A"
    :s_flush
  end

  def find_kinds_hand
    kinds = find_kinds
    return :four_kind if kinds.values.include?(4)
    return :full_house if kinds.values.include?(3) and kinds.values.include?(2)
    return :three_kind if kinds.values.include?(3)
    return :two_pair if kinds.select { |key, val| val == 2 }.size == 2
    return :one_pair if kinds.values.include?(2)
    :high_card
  end


  def determine_hand
    flush_hand = find_flush_hand
    kinds_hand = find_kinds_hand
    SETS.index(flush_hand) < SETS.index(kinds_hand) ? flush_hand : kinds_hand
  end
end