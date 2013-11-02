# -*- coding: utf-8 -*-

class Card

  SUIT_STRINGS = {
    :clubs    => "♣",
    :diamonds => "♦",
    :hearts   => "♥",
    :spades   => "♠"
  }

  SYMBOL_STRINGS = {
    :deuce => "2",
    :three => "3",
    :four  => "4",
    :five  => "5",
    :six   => "6",
    :seven => "7",
    :eight => "8",
    :nine  => "9",
    :ten   => "10",
    :jack  => "J",
    :queen => "Q",
    :king  => "K",
    :ace   => "A"
  }

  attr_reader :suit, :value, :symbol

  def initialize(suit = "♣", symbol = "A")
    @suit = suit
    @symbol = symbol
    @value = get_value
  end


  def <(other_card)
    return false if value > other_card.value
    return true if value < other_card.value
  end

  def >(other_card)
    return true if value > other_card.value
    return false if value < other_card.value
  end

  def <=>(other_card)
    return 1 if value > other_card.value
    return -1 if value < other_card.value
    0
  end

  protected


  def get_value
    case self.symbol
    when "A"
      14
    when "K"
      13
    when "Q"
      12
    when "J"
      11
    else
      self.symbol.to_i
    end
  end
end