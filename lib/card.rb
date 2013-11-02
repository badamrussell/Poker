# -*- coding: utf-8 -*-

class Card

  SUIT_STRINGS = {
    :clubs    => "♣",
    :diamonds => "♦",
    :hearts   => "♥",
    :spades   => "♠"
  }

  VALUE_STRINGS = {
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

  attr_reader :suit, :val

  def initialize(suit = "♣", value = "A")
    @suit = suit
    @val = value
    @number_value = num_value
  end


  def <=>(other_card)
    return 1 if number_value > other_card.number_value
    return -1 if number_value < other_card.number_value
    0
  end

  protected
  attr_reader :number_value

  def num_value
    case VALUE_STRINGS[other_card.value]
    when "A"
      14
    when "K"
      13
    when "Q"
      12
    when "J"
      11
    else
      VALUE_STRINGS[other_card.value].to_i
    end
  end
end