# -*- coding: utf-8 -*-
require_relative 'deck'
require_relative 'player'
require_relative 'hand'
require 'colorize'

class Game
  attr_reader :turn, :players, :ante, :deck
  attr_accessor :pot, :discard_pile, :deck

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

  def players_remaining
    players.count { |player| !player.folded }
  end

  def start_round
    puts "\n\n-$- All players ante up!"

    players.each do |player|
      if player.afford_bet?(self.ante)
        player.folded = false
        self.pot += player.bet(self.ante)
        player.hand = Hand.new(self.deck.draw(self.ante))
        puts "  #{player.name} antes #{self.ante} and is in the game!"
      else
        player.folded = true
        puts "  #{player.name} is sitting this one out."
      end
    end
  end

  def print_players(active_player, show_all = false)
    puts "============================================================".green
    puts "------------------------------------------------".green + "pot: $#{pot}".rjust(12)
    puts "============================================================".green

    players.each do |player|
      if player.folded
        puts "#{player.avatar} " + "#{player.name}:".ljust(10) + "  [ ☠ ]   [ ☠ ]   [ ☠ ]   [ ☠ ]   [ ☠ ]".ljust(44) + " $#{player.pot}"
      elsif player == active_player || show_all
        puts "#{player.avatar} " + "#{player.name}:".ljust(10) + player.hand.show.ljust(114) + " $#{player.pot}  #{player.hand.name} "
      else
        puts "#{player.avatar} " + "#{player.name}:".ljust(10) + player.hand.hide.ljust(114) + " $#{player.pot}"
      end
    end

    puts "\n"
  end

  def finished_betting?
    players.inject(0) { |sum, player| sum + player.call_bet } == 0
  end

  def betting_round(ante_up = false)
    puts "\n\n-$- Place your bets!"
    round_counter = 0

    players.each do |player|
      player.call_bet = 0
    end

    # ROUND MUST CONTINUE UNTIL ALL PLAYERS HAVE BET EQUAL AMOUNTS
    loop do
      round_counter += 1
      puts "BETTING ROUND: #{round_counter}".rjust(60)

      # EACH PLAYER HAS AN OPPORTUNITY TO FOLD OR BET
      players.each do |player|
        next if player.folded

        print_players(player)
        puts "call: $#{player.call_bet}".rjust(60)
        player.hand.show

        raise_amount = player.make_bet

        if raise_amount > 0
          call_amount = player.call_bet
          raise_amount -= player.call_bet

          players.each { |other_player| other_player.increase_call_bet(raise_amount) }

          self.pot += player.bet(raise_amount + call_amount)

          puts "\n"
          puts "#{player.name} calls $#{call_amount}".rjust(60) if call_amount > 0
          puts "#{player.name} raises $#{raise_amount}".rjust(60) if raise_amount > 0
        end

        return if players_remaining == 1
        return if finished_betting? && round_counter > 1 && player.call_bet == 0

        player.call_bet = 0
      end
    end
  end

  def draw_phase
    #each player may remove cards and replenish their hands
    puts "-?- Draw new cards!"

    players.each do |player|
      next if player.folded
      print_players(player)

      puts "#{player.name} your turn!"
      cards = player.hand.select_cards

      puts "  #{player.name} discarded #{cards.size} cards!".rjust(58)
      if cards.size > 0
        player.hand.discard(cards)
        self.discard_pile += cards
        player.hand.draw(deck, cards.size)
      end
    end
  end

  def showdown
    puts "-!- And the winner is..."

    print_players(nil, true)

    #players compare hands and a winner is determined
    players_left = players.select { |player| !player.folded }

    until players_left.size == 1
      versus = [players_left[0], players_left[1]]
      versus.reverse! if versus[1].hand.beats?(versus[0].hand)

      puts "#{versus[1].name}'s #{versus[1].hand.name} is beaten by #{versus[0].name}'s #{versus[0].hand.name}."
      puts "#{versus[1].name} is eliminated!".rjust(60)

      players_left.delete(versus[1])
    end

    puts " #{players_left[0].name} wins the $#{pot} pot!".rjust(60)
    players_left[0].hand.show

    nil
  end


  def play
    self.pot = 0
    self.deck.shuffle

    start_round
    betting_round
    draw_phase if players_remaining > 1
    betting_round if players_remaining > 1
    showdown
  end

  private
  #attr_writer :pot

end

def test_game
  game = Game.new

  granger = Player.new("Granger", 100, "♞")
  kiran = Player.new("Kiran", 100, "☕")
  brian = Player.new("Brian", 100, "☠")
  tim = Player.new("Tim", 100)

  game.add_player(granger)
  game.add_player(kiran)
  game.add_player(brian)
  game.add_player(tim)

  game.play
end

test_game