# -*- coding: utf-8 -*-

class Player
  attr_reader :pot, :name, :avatar
  attr_accessor :hand, :folded, :call_bet

  def initialize(name, pot, avatar = "☺")
    @name = name
    @pot = pot
    @avatar = avatar
    @call_bet = 0
  end

  def increase_call_bet(amount)
    self.call_bet += amount unless self.folded
  end

  def afford_bet?(amount)
    pot > amount
  end

  def bet(amount)
    bet_amount = amount
    if @pot > amount
      @pot -= amount
    else
      bet_amount = @pot
      @pot = 0
    end

    bet_amount
  end

  def turn_action
    print "#{self.name.capitalize}, (F)old, (B)et? or (C)all >"
    user_input = gets.downcase.chomp

    case user_input[0]
    when "f"
      :fold
    when "b"
      :bet
    when "c"
      :call
    else
      puts "Invalid command."
      turn_action
    end
  end

  def make_bet
    print "How much would you like to raise? (min $#{self.call_bet}) >"
    new_bet = gets.chomp.to_i.abs

    if new_bet > pot
      puts "That bet is invalid"
      new_bet = 0
    elsif new_bet < self.call_bet
      puts "You must bet at least $#{self.call_bet}"
      new_bet = 0
    end

    new_bet
  end
end