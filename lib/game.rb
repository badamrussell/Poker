require_relative 'deck'
require_relative 'player'
require_relative 'hand'

class Game
  attr_reader :deck, :turn, :players, :ante, :deck
  attr_accessor :pot

  def initialize
    @deck = Deck.new
    @discard_pile = []
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

  def players_remaining
    players.count { |player| !player.folded }
  end

  def start_round
    puts "------------------------------"
    puts "-$- All players ante up!"
    puts "------------------------------"

    self.pot = 0
    self.deck.shuffle

    players.each do |player|
      if player.afford_bet?(self.ante)
        player.folded = false
        @pot += player.bet(self.ante)
        player.hand = Hand.new(self.deck.draw(5))
        puts "  #{player.name} antes 5 and is in the game!"
      else
        player.folded = true
        puts "  #{player.name} is sitting this one out."
      end
    end

  end

  def betting_round
    puts "------------------------------"
    puts "-$- Place your bets!"
    puts "------------------------------"
    bets = Array.new(players.size, 0)
    round_counter = 0

    while bets.inject(:+) > 0 || round_counter == 0
      round_counter += 1

      players.each_with_index do |player, index|
        next if player.folded

        puts "#{player.name} your turn!"
        puts "   pot: #{pot}" + "   call: #{bets[index]}".rjust(20)
        player.hand.render
        action, call_amount, raise_amount = player.bet_action(bets[index])

        self.pot += player.bet(raise_amount+call_amount)
        p bets
        puts ">>>>> #{action}, #{call_amount}, #{raise_amount}"

        case action

        when :fold
          player.folded = true
          bets[index] = 0
          puts "  #{player.name} folds! #{players_remaining} players left!"
        when :raise
          puts "  #{player.name} calls #{call_amount} and raises #{raise_amount}"
          bets[index] -= call_amount

          bets.each_with_index do |amount, other_index|
            next if players[other_index].folded
            next if other_index == index
            bets[other_index] += raise_amount
          end
        when :call
          puts "  #{player.name} calls #{call_amount}"
          bets[index] -= call_amount
        end

        puts "=============================================="
        return if players_remaining == 1
      end


    end
  end

  def draw_phase
    #each player may remove cards and replenish their hands
    puts "------------------------------"
    puts "-?- Draw new cards!"
    puts "------------------------------"

    players.each do |player|
      cards = player.hand.select_cards

      if cards.size > 0
        player.hand.discard(cards)
        discard_pile += cards
        player.hand.draw(deck, cards.size)
      end
    end
  end

  def showdown
    puts "------------------------------"
    puts "-!- And the winner is..."
    puts "------------------------------"

    #players compare hands and a winner is determined
    if players_remaining == 1
      winner = players.select { |player| !player.folded }[0]
      puts winner.name.center(30)
      winner.hand.render
    end
  end


  def play
    #collects a pot from each player
    #deals a hand to each player


    start_round

    betting_round

    draw_phase if players_remaining > 1

    betting_round if players_remaining > 1

    showdown
  end

  private
  #attr_writer :pot

end

game = Game.new

granger = Player.new("Granger", 100)
kiran = Player.new("Kiran", 100)
brian = Player.new("Brian", 100)
prashant = Player.new("Prashant", 100)

game.add_player(granger)
game.add_player(kiran)
game.add_player(brian)
game.add_player(prashant)

game.play