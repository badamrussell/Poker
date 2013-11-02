require 'deck'

class Game
  attr_reader :deck, :turn, :players, :ante, :deck, :pot


  def initialize
    @deck = Deck.new
    @players = []
    @turn = 0
    @pot = 0
    @ante = 5
  end

  def add_player(player)
    self.players << player
  end

  def current_player
    self.players[self.turn]
  end

  def player_turn

  end

  def start_round
    @pot = 0
    self.deck.shuffle

    players.each do |player|
      if player.afford_bet?(self.ante)
        player.folded = false
        @pot += player.bet(self.ante)
        player.hand = self.deck.draw(5)
      else
        player.folded = true
      end
    end
  end

  def betting_round
    bets = Array.new(players.size, 0)

    while bets.inject(:+) > 0 || players.count { |player| !player.folded } > 1
      players.each_with_index do |player, index|
        next if player.folded

        action, call_amount, raise_amount = player.action(bets[index])

        case action

        when :fold
          player.folded = true
          bets[index] = 0
        when :raise
          # raise - raises current bet
          # all other players now must match this
          bets.each_with_index do |amount, other_index|
            next if players[other_index].folded?
            next if other_index == index
            bets[index] += raise_amount
          end
        when :call
          # call - match current bet
          bets[index] -= call_amount
        when :check
          # check - bet zero (only works if no one has raised)
        end
      end
    end

    #gone through each player
    #does any player need to match bets?


    #players may fold, call or raise, check
    # fold - give up



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

    start_round

    betting_round

    draw_phase

    betting_round

    showdown
  end

  private
  attr_writer :pot

end