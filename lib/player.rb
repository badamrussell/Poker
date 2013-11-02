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
    print "Fold, Raise or Call?  >"
    user_input = gets.downcase.chomp

    case user_input[0]
    when "f"
      :fold
    when "r"
      :raise
    when "c"
      :call
    else
      ui_action
    end
  end

  def ui_bet
    print "How much would you like to raise? (max 10) >"
    new_bet = gets.chomp.to_i.abs

    if user_input > pot || user_input > 10
      puts "That bet is invalid"
      new_bet = 0
    end

    new_bet
  end

  def bet_action(bet_owed)
    raise_amount = 0
    call_amount = 0

    action_name = ui_action
    raise_amount = ui_bet if action_name == :raise

    temp_pot = pot - bet_owed

    while action_name == :raise
      if raise_amount == 0 || raise_amount > temp_pot
        action_name = ui_action
        raise_amount = ui_bet if action_name == :raise
      else
        break
      end
    end

    call_amount = bet_owed unless action_name == :fold

    [action_name, call_amount, raise_amount]
  end

end