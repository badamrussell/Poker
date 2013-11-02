class Player
  attr_reader :pot, :name
  attr_accessor :hand, :folded

  def initialize(name, pot)
    @name = name
    @pot = pot
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

  def bet_action(bet_owed)
    available_actions = [:fold, :raise]
    if bet_owed == 0
      available_actions << :check
    else
      available_actions << :call
    end

    action_name, call_amount, raise_amount = :fold, 0, 0

    [action_name, call_amount, raise_amount]
  end

end