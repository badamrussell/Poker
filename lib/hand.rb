# -*- coding: utf-8 -*-

class Hand

  SETS = [:r_flush,
          :s_flush,
          :four_kind,
          :full_house,
          :flush,
          :straight,
          :three_kind,
          :two_pair,
          :one_pair,
          :high_card]

  attr_reader :cards, :hand_size

  def initialize(cards,hand_size = 5)
    @cards = cards
    @hand_size = hand_size
  end

  def size
    self.cards.size
  end

  def determine_hand
    flush_hand = find_flush_hand
    kinds_hand = find_kinds_hand
    SETS.index(flush_hand) < SETS.index(kinds_hand) ? flush_hand : kinds_hand
  end

  def beats?(other_hand)
    SETS.index(determine_hand) < SETS.index(other_hand.determine_hand)
  end

  def select_cards

  end

  def discard(discard_cards)
    raise "cannot discard that many cards" if discard_cards.size > size
    discard_cards.each do |card|
      @cards -= [card]
    end
  end

  def draw(number, deck)
    @cards += deck.draw(number)
  end

  protected

  def score
    # hand_set_value + hand_set_value_high_card(n) + high_card
  end

  private

  def find_kinds
    {}.tap do |kinds|
      @cards.each do |card|
        kinds[card.symbol] = count(card)
      end
    end
  end

  def high_card
    @cards.sort.last
  end

  def flush?
    suit = @cards[0].suit
    @cards.all? { |my_card| my_card.suit == suit }
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


end