require 'deck'

class Game
  attr_reader :pot, :deck, :turn

  initialize
    @deck = Deck.new
    @players = []
    @turn = 0
    @pot = 0
  end

  def add_player(player)
    self.players << player
  end

  def current_player
    self.players[self.turn]
  end

  def player_turn

  end

  def betting_round
    #players may fold, call or raise, check
    # fold - give up
    # call - match current bet
    # raise - raises current bet
    # check - bet zero (only works if no one has raised)
    #round ends when all players have bet the same
  end

  def draw_phase
    #each player may remove cards and replenish their hands
  end

  def showdown
    #players compare hands and a winner is determined
  end

  def play
    #collects a pot from each player
    #deals a hand to each player

    betting_round

    draw_phase

    betting_round

    showdown
  end

end