# -*- coding: utf-8 -*-

class Player
  attr_reader :pot, :name, :avatar
  attr_accessor :hand, :folded, :minimum_bet

  def initialize(name, pot, avatar = "☺")
    @name = name
    @pot = pot
    @avatar = avatar
    @minimum_bet = 0
  end

  def reset_bet
    self.minimum_bet = 0
  end

  def add_to_min_bet(amount)
    self.minimum_bet += amount unless self.folded
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
    print "(F)old or (B)et?  >"
    user_input = gets.downcase.chomp

    case user_input[0]
    when "f"
      puts " #{self.name} folds!"
      :fold
    else
      :bet
    else
      puts "Invalid command."
      ui_action
    end
  end

  def make_bet(minimum_bet)
    print "How much would you like to raise? (min $#{minimum_bet}) >"
    new_bet = gets.chomp.to_i.abs

    if new_bet > pot
      puts "That bet is invalid"
      new_bet = 0
    elsif new_bet < minimum_bet
      puts "You must bet at least $#{minimum_bet}"
      new_bet = 0
    end

    new_bet
  end
end