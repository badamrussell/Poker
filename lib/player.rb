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

  def ui_action
    available_actions = [:fold, :raise, :call]
    choice = 2


    available_actions[choice]
  end

  def ui_bet
    20
  end

  def bet_action(bet_owed)


    action_name = ui_action

    return [:fold, 0, 0] if action_name == :fold

    return [:call, bet_owed, 0] if action_name == :call && afford_bet?(bet_owed)


    #new_bet =

    #while new_bet
    action_name, call_amount, raise_amount = :fold, 0, 0

    #bet must be minumum of bet_owed

    [action_name, call_amount, raise_amount]
  end

end